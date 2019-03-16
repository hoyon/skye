defmodule Ema.Recipe do
  alias Ema.Template

  def recipe do
    %{
      input: %{"user_id" => 3},
      steps: [
        {Ema.Service.Placeholder, :get_user, &input/1},
        {Ema.Service.Dummy, :greet, &transform1/1},
        {Ema.Service.Telegram, :send_message, &transform2/1}
      ],
      results: %{}
    }
  end

  def run_recipe(recipe) do
    Enum.reduce(recipe.steps, recipe, fn step, recipe ->
      trans = elem(step, 2)
      input = trans.(recipe)

      {:ok, result} = Ema.run_sync(elem(step, 0), elem(step, 1), input)

      results = Map.merge(recipe.results, result)

      Map.put(recipe, :results, results)
    end)
  end

  def transform1(recipe) do
    name = eval_template("Bob <{{username}}> Smith", recipe.results)

    %{"name" => name}
  end

  def transform2(recipe) do
    text = eval_template("Message from Skye: {{text}}", recipe.results)
    %{"text" => text}
  end

  def input(recipe) do
    recipe.input
  end

  defp eval_template(template, results) do
    {:ok, ast} = Template.parse(template)

    Enum.reduce(ast, "", fn item, acc ->
      case item do
        {:str, string} -> acc <> string
        {:expr, expression} -> acc <> Map.get(results, expression)
      end
    end)
  end
end
