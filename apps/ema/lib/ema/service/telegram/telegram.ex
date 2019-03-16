defmodule Ema.Service.Telegram do
  use Ema.Service
  alias Ema.Service.Telegram.Api

  name "Telegram"
  description "Sends message via telegram"

  env :telegram, [:token, :chat_id]

  type :send_response do
    ok :string, "status"
  end

  type :message do
    text :string, "The message"
  end

  action :send_message, :message, :send_response, %{"text" => text} do
    {:ok, res} = Api.send_message(text)
    {:ok, res.body}
  end
end
