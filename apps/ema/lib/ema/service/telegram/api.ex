defmodule Ema.Service.Telegram.Api do
  use Tesla
  alias Ema.Service.Telegram

  plug Tesla.Middleware.BaseUrl, "https://api.telegram.org/bot#{Telegram.env_token()}"
  plug Tesla.Middleware.JSON

  @callback send_message(binary()) :: term()
  def send_message(message) do
    {:ok, response} = post("/sendMessage",
      %{"chat_id" => Telegram.env_chat_id(),
        "text" => message})

    if response.body["ok"] do
      {:ok, %{"sent_message" => response.body["result"]["text"]}}
    else
      {:error, "Failed to send message"}
    end
  end
end
