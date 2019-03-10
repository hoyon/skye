defmodule Ema.Service do
  alias Ema.{Type, Util}

  @service_function :__ema_service
  @name_function :__ema_name
  @description_function :__ema_description
  @env_function :__ema_env_check

  @action_prefix "__ema_action_"
  @type_prefix "__ema_type_"
  @env_prefix "env_"

  defmacro __using__(_opts) do
    quote do
      import Ema.Service
      import Ema.Type, only: [type: 2, type: 3]

      def unquote(@service_function)(), do: true
    end
  end

  def is_service?(module) when is_atom(module) do
    Util.has_function?(module, @service_function)
  end

  def run(service, action, input) do
    %{input: input_type} = actions(service)[action]

    if Type.check_type(input, input_type) do
      service.action(action, input)
    else
      {:error, "#{service}: Action #{action} expects #{input_type} but got #{inspect(input)}"}
    end
  end

  # Actions
  defmacro action(act, input, output, params, do: body) do
    fun_name = :"#{@action_prefix}#{act}"

    info_ast =
      quote do
        def unquote(fun_name)() do
          %{action: unquote(act), input: unquote(input), output: unquote(output)}
        end
      end

    params = Macro.escape(params)
    body = Macro.escape(body, unquote: true)

    act_ast =
      quote bind_quoted: [fun_name: fun_name, act: act, params: params, body: body] do
        def action(unquote(act), unquote(params)) do
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

  defmacro name(n) when is_binary(n) do
    quote do
      def unquote(@name_function)() do
        unquote(n)
      end
    end
  end

  defmacro description(d) when is_binary(d) do
    quote do
      def unquote(@description_function)() do
        unquote(d)
      end
    end
  end

  @doc "Get the metadata for a service"
  def metadata(service) when is_atom(service) do
    name =
      if Util.has_function?(service, @name_function) do
        apply(service, @name_function, [])
      else
        nil
      end

    description =
      if Util.has_function?(service, @description_function) do
        apply(service, @description_function, [])
      else
        nil
      end

    %{name: name, description: description}
  end

  # Initialisation

  defmacro env(key, vars) when is_atom(key) and is_list(vars) do
    check_ast =
      quote do
        def unquote(@env_function)() do
          set = Application.get_env(:ema, unquote(key)) || []

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
        fun_name = :"#{unquote(@env_prefix)}#{var}"

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
