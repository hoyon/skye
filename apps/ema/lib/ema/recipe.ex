defmodule Ema.Recipe do

  def run_recipe do
    {:ok, result} = Ema.run_sync(Ema.Service.Placeholder, :get_post, %{post_id: 2})

    input = make_input(%{steps: [result]})
    Ema.run_sync(Ema.Service.Dummy, :echo, input)
  end

  def make_input(env) do
    title = Enum.at(env.steps, 0)["title"]
    %{text: "Title: #{title}"}
  end
end
