defmodule Ema.Recipe do

  def run_recipe do
    {:ok, result} = Ema.run_sync(Ema.Service.Placeholder, :get_post, 2)

    input = make_input(%{steps: [result]})
    Ema.run_sync(Ema.Service.Echo, :echo, input)
  end

  def make_input(env) do
    Enum.at(env.steps, 0)["title"]
  end
end
