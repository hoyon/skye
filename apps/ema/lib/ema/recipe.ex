defmodule Ema.Recipe do
  defstruct steps: [], state: %{}
  alias Ema.Template

  def recipe do
    %__MODULE__{
      steps: [
        {Ema.Service.Placeholder, :get_user, %{"user_id" => "{{user_id}}"}},
        {Ema.Service.Dummy, :greet, %{"name" => "Bob <{{username}}> Smith"}},
        {Ema.Service.Telegram, :send_message, %{"text" => "Message from Skye: {{text}}"}}
      ],
      state: %{"user_id" => "2"}
    }
  end

  def run(%__MODULE__{} = recipe, inputs \\ %{}) when is_map(inputs) do
    recipe = Map.put(recipe, :state, inputs)

    Enum.reduce(recipe.steps, recipe, fn step, recipe ->
      trans = elem(step, 2)
      input = run_transformation(trans, recipe.state)

      {:ok, result} = Ema.run_sync(elem(step, 0), elem(step, 1), input)

      Map.update!(recipe, :state, &Map.merge(&1, result))
    end)
  end

  defp run_transformation(transform, state) do
    transform
    |> Enum.map(fn {k, v} -> {k, eval_template(v, state)} end)
    |> Enum.into(%{})
  end

  defp eval_template(template, state) do
    {:ok, ast} = Template.parse(template)

    Enum.reduce(ast, "", fn item, acc ->
      case item do
        {:str, string} -> acc <> string
        {:expr, expression} -> acc <> Map.get(state, expression)
      end
    end)
  end
end
