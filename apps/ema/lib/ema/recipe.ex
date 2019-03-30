defmodule Ema.Recipe do
  alias Ema.Template

  def recipe do
    %{
      steps: [
        {Ema.Service.Placeholder, :get_user, %{"user_id" => "{{user_id}}"}},
        {Ema.Service.Dummy, :greet, %{"name" => "Bob <{{username}}> Smith"}},
        {Ema.Service.Telegram, :send_message, %{"text" => "Message from Skye: {{text}}"}}
      ],
      inputs: %{"user_id" => "4"}
    }
  end

  def run_recipe(recipe) do
    Enum.reduce(recipe.steps, recipe, fn step, recipe ->
      trans = elem(step, 2)
      input = run_transformation(trans, recipe.inputs)

      {:ok, result} = Ema.run_sync(elem(step, 0), elem(step, 1), input)

      Map.update!(recipe, :inputs, &Map.merge(&1, result))
    end)
  end

  def run_transformation(transform, inputs) do
    transform
    |> Enum.map(fn {k, v} -> {k, eval_template(v, inputs)} end)
    |> Enum.into(%{})
  end

  defp eval_template(template, inputs) do
    {:ok, ast} = Template.parse(template)

    Enum.reduce(ast, "", fn item, acc ->
      case item do
        {:str, string} -> acc <> string
        {:expr, expression} -> acc <> Map.get(inputs, expression)
      end
    end)
  end
end
