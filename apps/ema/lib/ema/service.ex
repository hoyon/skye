defmodule Ema.Service do
  alias Ema.Service.Type
  alias Ema.Util

  @action_prefix "__ema_action_"
  @type_prefix "__ema_type_"

  defmacro __using__(_opts) do
    quote do
      import Ema.Service

      def __ema_service, do: true
    end
  end

  def run(service, action, input) do
    %{input: input_type} = actions(service)[action]

    if Type.check_type(input, input_type) do
      service.action(action, input)
    else
      {:error, "#{service}: Action #{action} expects #{input_type} but got #{input}"}
    end
  end

  # Actions
  defmacro action(act, input, output, do: body) do
    fun_name = :"#{@action_prefix}#{act}"

    info_ast =
      quote do
        def unquote(fun_name)() do
          %{action: unquote(act), input: unquote(input), response: unquote(output)}
        end
      end

    # Not really sure why this works
    input = Macro.escape({:input, [], nil})
    body = Macro.escape(body, unquote: true)

    act_ast =
      quote bind_quoted: [fun_name: fun_name, act: act, input: input, body: body] do
        def action(unquote(act), unquote(input)) do
          unquote(body)
        end
      end

    [info_ast, act_ast]
  end

  def actions(service) when is_atom(service) do
    service.__info__(:functions)
    |> Enum.filter(fn {fun, arity} ->
      String.starts_with?("#{fun}", @action_prefix) and arity == 0
    end)
    |> Enum.map(fn {fun, 0} ->
      name = String.replace_prefix("#{fun}", @action_prefix, "")
      info = apply(service, fun, [])
      {String.to_atom(name), info}
    end)
  end

  # Types

  @doc "Macro for defining types using DSL"
  defmacro type(name, block) when is_atom(name) do
    exprs =
      case block do
        [do: {:__block__, _, exprs}] -> exprs
        [do: expr] -> [expr]
      end

    acc =
      quote do
        %Type{name: unquote(name)}
      end

    body =
      Enum.reduce(exprs, acc, fn expr, acc ->
        quote do
          unquote(acc) |> unquote(expr)
        end
      end)

    fun_name = :"#{@type_prefix}#{name}"

    quote do
      def unquote(fun_name)() do
        import Type
        unquote(body)
      end
    end
  end

  @doc "Get all types definined in a service"
  def types(service) when is_atom(service) do
    service.__info__(:functions)
    |> Enum.filter(fn {fun, arity} ->
      String.starts_with?("#{fun}", @type_prefix) and arity == 0
    end)
    |> Enum.map(fn {fun, 0} ->
      name = String.replace_prefix("#{fun}", @type_prefix, "")
      info = apply(service, fun, [])
      {String.to_atom(name), info}
    end)
  end

  # Metadata
  defmodule Metadata do
    @moduledoc """
    Struct for service metadata
    """
    defstruct name: nil, description: nil
  end

  defmacro name(n) do
    quote do
      def __ema_service_name do
        unquote(n)
      end
    end
  end

  defmacro description(d) do
    quote do
      def __ema_service_description do
        unquote(d)
      end
    end
  end

  @doc "Get the metadata for a service"
  def metadata(service) when is_atom(service) do
    name =
      try do
        service.__ema_service_name()
      rescue
        _ -> nil
      end

    description =
      try do
        service.__ema_service_description()
      rescue
        _ -> nil
      end

    %{name: name, description: description}
  end

  # Initialisation
  @env_function :__ema_service_env

  defmacro env(key, vars) when is_atom(key) and is_list(vars) do
    check_ast =
      quote do
        def unquote(@env_function)() do
          set = Application.get_env(:ema, unquote(key))

          unquote(vars)
          |> Enum.map(fn v -> Keyword.get(set, v, nil) != nil end)
          |> Enum.all?(& &1)
          |> case do
            true -> :ok
            false -> raise "Required environment variables for #{__MODULE__} not defined"
          end
        end
      end

    env_asts =
      vars
      |> Enum.map(fn var ->
        fun_name = :"env_#{var}"

        quote do
          def unquote(fun_name)() do
            Application.get_env(:ema, unquote(key))[unquote(var)]
          end
        end
      end)

    [check_ast | env_asts]
  end

  def init(service) when is_atom(service) do
    if Util.has_function?(service, @env_function) do
      apply(service, @env_function, [])
    end
  end
end
