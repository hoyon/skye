defmodule Ema.Type do

  # Type DSL
  def description(t, d) do
    %{t | description: d}
  end

  defmodule Property do
    defstruct name: nil, description: nil, type: nil
  end

  defstruct name: nil, description: nil, properties: %{}

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

  # Other helper functions
  def check_type(i, :string) when is_binary(i), do: true
  def check_type(i, :integer) when is_integer(i), do: true
  def check_type(_, :string), do: false
  def check_type(_, :integer), do: false
  def check_type(_, _), do: true # TODO proper type checking
end
