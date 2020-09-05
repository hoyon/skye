defmodule Ema.Recipe do
  defstruct steps: [], state: %{}
  alias Ema.Template

  def recipe do
    %__MODULE__{
      steps: [
        {Ema.Service.Placeholder, :get_user, %{"user_id" => "{{user_id}}"}},
        {Ema.Service.Dummy, :greet, %{"name" => "{{name}} aka {{username}}"}},
        {Ema.Service.Telegram, :send_message, %{"text" => "Message from Skye: {{text}}"}}
      ],
      state: %{"user_id" => "2"}
    }
  end

  def run(%__MODULE__{} = recipe, inputs \\ %{}) when is_map(inputs) do
    recipe = Map.put(recipe, :state, inputs)

    case run_steps(recipe) do
      {:error, error} ->
        {:error, error}

      result ->
        {:ok, result}
    end
  end

  defp run_steps(recipe) do
    Enum.reduce_while(recipe.steps, recipe, fn step, recipe ->
      trans = elem(step, 2)
      state = run_transformation(trans, recipe.state)

      run_result = Ema.run_sync(elem(step, 0), elem(step, 1), state)

      case run_result do
        {:ok, result} ->
          recipe = Map.update!(recipe, :state, &Map.merge(&1, result))
          {:cont, recipe}

        {:error, error} ->
          # TODO return result of previous successful steps
          {:halt, {:error, error}}
      end
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
        {:expr, expression} ->
          acc <> get_val!(state, expression)
      end
    end)
  end

  defp get_val!(state, expression) do
    if val = Map.get(state, expression) do
      val
    else
      raise """
      Variable #{expression} not found
      """
    end
  end
end
