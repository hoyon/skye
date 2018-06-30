defmodule Ema.Service do
  @action_prefix "__ema_action_"
  @type_prefix "__ema_type_"

  defmodule Metadata do
    @moduledoc """
    Struct for service metadata
    """
    defstruct name: nil, description: nil
  end

  def run(service, action, input) do
    %{input: input_type} = actions(service)[action]

    if check_type(input, input_type) do
      service.action(action, input)
    else
      {:error, "#{service}: Action #{action} expects #{input_type} but got #{input}"}
    end
  end

  def check_type(i, :string) when is_binary(i), do: true
  def check_type(i, :integer) when is_integer(i), do: true
  def check_type(_, _), do: false

  defmacro __using__(_opts) do
    quote do
      import Ema.Service

      def __ema_service, do: true
    end
  end

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

  defmodule Property do
    @moduledoc """
    A struct for properties of types
    """
    defstruct name: nil, description: nil, type: nil
  end

  defmodule Type do
    @moduledoc """
    Functions for type definition DSL
    """

    defstruct name: nil, description: nil, properties: %{}

    def description(t, d) do
      %{t | description: d}
    end

    def property(t, name, type, description \\ nil)
        when is_atom(type) and is_binary(description) do
      updated =
        Map.put(t.properties, name, %Property{name: name, description: description, type: type})

      %{t | properties: updated}
    end

    defmacro properties(t, block) do
      exprs =
        case block do
          [do: {:__block__, _, exprs}] -> exprs
          [do: expr] -> [expr]
        end

      body =
        exprs
        |> Enum.map(fn {name, line, args} -> {:property, line, [name | args]} end)
        |> Enum.reduce(t, fn expr, acc ->
          quote do
            unquote(acc) |> unquote(expr)
          end
        end)

      body
    end
  end

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
end
