defmodule Ema.Service do
  @action_prefix "__ema_action_"
  @type_prefix "__ema_type_"

  defmodule Metadata do
    defstruct name: nil, description: nil
  end

  def run(service, action, args) do
    service.action(action, args)
  end

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
    args = Macro.escape({:args, [], nil})
    body = Macro.escape(body, unquote: true)

    act_ast =
      quote bind_quoted: [fun_name: fun_name, act: act, args: args, body: body] do
        def action(unquote(act), unquote(args)) do
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
      {name, info}
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

  defmodule Type do
    @moduledoc """
    Functions for type definition DSL
    """

    defstruct name: nil, description: nil, properties: %{}

    def description(t, d) do
      %{t | description: d}
    end

    def property(t, name, type, description \\ nil) do
      updated = Map.put(t.properties, name, %Type{name: name, description: description})
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

  defmacro type(name, block) do
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
end
