defmodule Ema.ServiceCase do
  use ExUnit.CaseTemplate
  alias Ema.Service
  alias Ema.Service.Type

  using opts do
    quote(bind_quoted: [opts: opts]) do
      import Ema.ServiceCase

      @service Keyword.get(opts, :service)
      test_service_sanity @service
    end
  end
  
  @doc "Ensure action returns correct type for a given input"
  defmacro test_action_type(action, input) do
    quote do
      test_action_type(@service, unquote(action), unquote(input))
    end
  end

  defmacro test_action_type(service, action, input) do
    quote do
      test "#{unquote(service)}.#{unquote(action)} #{unquote(input)}" do
        service = unquote(service)
        action = unquote(action)
        input = unquote(input)

        output_type = Service.actions(service)[action].response
        {:ok, result} = Service.run(service, action, input)
        assert Type.check_type(result, output_type)
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
        :__ema_service_name,
        :__ema_service_description
      ]

      test "#{unquote(service)} sanity test" do
        functions = apply(unquote(service), :__info__, [:functions])

        assert @required_functions
          |> Enum.map(fn f -> Keyword.has_key?(functions, f) end)
          |> Enum.all?(& &1)

        metadata = Service.metadata(unquote(service))
        assert is_binary(metadata.name)
        assert is_binary(metadata.description)
      end
    end
  end
end