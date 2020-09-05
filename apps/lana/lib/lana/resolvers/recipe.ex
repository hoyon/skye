defmodule Lana.Resolvers.Recipe do
  alias Ema.Recipe

  def recipe do
    %Recipe{
      steps: [
        {Ema.Service.Placeholder, :get_user, %{"user_id" => "{{user_id}}"}},
        {Ema.Service.Dummy, :greet, %{"name" => "{{name}} aka {{username}}"}},
        {Ema.Service.Telegram, :send_message, %{"text" => "Message from Skye: {{text}}"}}
      ]
    }
  end

  def run(_, _, _) do
    Recipe.run(Recipe.recipe, %{"user_id" => "234"})
    {:ok, true}
  end
end
