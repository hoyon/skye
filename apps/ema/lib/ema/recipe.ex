defmodule Ema.Recipe do
  def recipe do
    %{
      input: %{user_id: 3},
      steps: [
        {Ema.Service.Placeholder, :get_user, &input/1},
        {Ema.Service.Dummy, :greet, &transform1/1},
        {Ema.Service.Telegram, :send_message, &transform2/1}
      ],
      results: []
    }
  end

  def run_recipe(recipe) do
    Enum.reduce(recipe.steps, recipe, fn step, recipe ->
      trans = elem(step, 2)
      input = trans.(recipe)

      {:ok, result} = Ema.run_sync(elem(step, 0), elem(step, 1), input)

      Map.update!(recipe, :results, fn rs -> rs ++ [result] end)
    end)
  end

  def transform1(recipe) do
    username = Enum.at(recipe.results, 0).username
    %{name: username}
  end

  def transform2(recipe) do
    message = Enum.at(recipe.results, 1).text
    %{text: message}
  end

  def input(recipe) do
    recipe.input
  end
end
