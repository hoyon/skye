defmodule Lana.Resolvers.Recipe do
  alias Ema.Recipe

  def run(_, _, _) do
    Recipe.run(Recipe.recipe)
    {:ok, true}
  end
end
