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

  type :received_message do
    body :string, "The body of the message"
    from :string, "Who the message was from"
    chat_id :integer, "The chat id"
  end

  trigger :got_message, :received_message, params do
    body = params["message"]["text"]
    from = params["message"]["from"]["first_name"]
    chat_id = params["message"]["chat"]["id"]
    {:ok, %{"body" => body, "from" => from, "chat_id" => "#{chat_id}"}}
  end

  action :send_message, :message, :send_response, %{"text" => text} do
     @api.send_message(text)
  end
end
