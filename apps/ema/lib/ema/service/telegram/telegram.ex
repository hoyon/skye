defmodule Ema.Service.Telegram do
  use Ema.Service

  @api Application.get_env(:ema, :telegram_api, Ema.Service.Telegram.Api)

  name "Telegram"
  description "Sends message via telegram"

  env :telegram, [:token, :chat_id]

  type :send_response do
    sent_message :string
  end

  type :message do
    text :string, "The message"
  end

  action :send_message, :message, :send_response, %{"text" => text} do
     @api.send_message(text)
  end
end
