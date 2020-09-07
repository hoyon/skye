defmodule Ema.ServiceCase do
  use ExUnit.CaseTemplate
  alias Ema.{Service, Type}

  using opts do
    quote bind_quoted: [opts: opts] do
      import Ema.ServiceCase
      import Mox

      @service Keyword.fetch!(opts, :service)
      test_service_sanity(@service)
    end
  end

  @doc "Ensure action returns correct type for a given input"
  defmacro test_action(action, input, output) do
    quote do
      test "action #{@service}.#{unquote(action)} with input #{inspect(unquote(input))}" do
        service = @service
        action = unquote(action)
        input = unquote(input)
        output = unquote(output)

        output_typename = Service.actions(service)[action].output
        {:ok, result} = Service.run(service, action, input)
        assert Type.check_type(result, service, output_typename)
        assert result == output
      end
    end
  end

  @doc "Ensure trigger returns correct type for a given input"
  defmacro test_trigger(trigger, input, output) do
    quote do
      test "trigger #{@service}.#{unquote(trigger)} with input #{inspect(unquote(input))}" do
        service = @service
        trigger = unquote(trigger)
        input = unquote(input)
        output = unquote(output)

        output_typename = Service.triggers(service)[trigger].output
        assert {:ok, result} = Service.run_trigger(service, trigger, input)
        assert Type.check_type(result, service, output_typename)
        assert result == output
      end
    end
  end

  @doc """
  Ensure that the service has all required fields
  Required fields:
  - name
  - description
  """
  defmacro test_service_sanity(service) do
    quote do
      @required_functions [
        :__ema_service,
        :__ema_name,
        :__ema_description
      ]

      test "#{unquote(service)} sanity test" do
        # Required functions
        functions = apply(unquote(service), :__info__, [:functions])

        assert @required_functions
               |> Enum.map(fn f -> Keyword.has_key?(functions, f) end)
               |> Enum.all?(& &1)
      end
    end
  end
end
