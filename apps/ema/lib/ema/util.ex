defmodule Ema.Util do
  def has_function?(mod, function) do
    functions = mod.__info__(:functions)
    Keyword.has_key?(functions, function)
  end
end
