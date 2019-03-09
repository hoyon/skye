defmodule Gant.Telegram.Api do
  use Tesla
  alias Gant.Telegram

  @token Telegram.env_token()
  @chat_id Application.get_env(:ema, :telegram)[:chat_id]

  plug(Tesla.Middleware.BaseUrl, "https://api.telegram.org/bot#{@token}")
  plug(Tesla.Middleware.JSON)

  def send_message(message) do
    post("/sendMessage", %{"chat_id" => @chat_id, "text" => message})
  end
end
