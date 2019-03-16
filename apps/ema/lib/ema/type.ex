defmodule Ema.Type do
  defstruct name: nil, description: nil, service: nil, properties: %{}

  defmodule Property do
    defstruct name: nil, description: nil, type: nil
  end

  # TODO put this in own module
  @type_prefix "__ema_type_"

  @doc "Macro for defining types using DSL"
  defmacro type(name, description \\ "", block) when is_atom(name) and is_binary(description) do
    exprs =
      case block do
        [do: {:__block__, _, exprs}] -> exprs
        [do: expr] -> [expr]
      end

    acc =
      quote do
        %Ema.Type{name: unquote(name), description: unquote(description), service: __MODULE__}
      end

    body =
      exprs
      |> Enum.map(fn {name, line, args} -> {:property, line, [name | args]} end)
      |> Enum.reduce(acc, fn expr, acc ->
        quote do
          unquote(acc) |> unquote(expr)
        end
      end)

    fun_name = :"#{@type_prefix}#{name}"

    quote do
      def unquote(fun_name)() do
        import Ema.Type
        unquote(body)
      end
    end
  end

  def property(t, name, type, description \\ "") when is_atom(type) and is_binary(description) do
    name = Atom.to_string(name)

    if Map.has_key?(t.properties, name) do
      raise "#{t.service}: Type '#{t.name}' has multiple definitions for field '#{name}'"
    else
      updated =
        Map.put(t.properties, name, %Property{name: name, description: description, type: type})

      %{t | properties: updated}
    end
  end

  # Type checking
  def check_type(value, service, typename) do
    type = apply(service, :"#{@type_prefix}#{typename}", [])
    check_type(value, type)
  end

  def check_type(value, %Ema.Type{} = type) do
    type.properties
    |> Enum.map(fn {_key, prop} -> check_primative_type(Map.get(value, prop.name), prop.type) end)
    |> Enum.all?(& &1)
  end

  def check_primative_type(v, :string) when is_binary(v), do: true
  def check_primative_type(v, :integer) when is_integer(v), do: true
  def check_primative_type(_, :string), do: false
  def check_primative_type(_, :integer), do: false
  def check_primative_type(_, _), do: false
end
