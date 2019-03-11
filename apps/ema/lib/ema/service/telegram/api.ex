defmodule Ema.Service.Telegram.Api do
  use Tesla
  alias Ema.Service.Telegram

  plug(Tesla.Middleware.BaseUrl, "https://api.telegram.org/bot#{Telegram.env_token()}")
  plug(Tesla.Middleware.JSON)

  def send_message(message) do
    post("/sendMessage", %{"chat_id" => Telegram.env_chat_id(), "text" => message})
  end
end
