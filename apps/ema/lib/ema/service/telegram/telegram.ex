defmodule Ema.Service.Telegram do
  use Ema.Service
  alias Ema.Service.Telegram.Api

  name "Telegram"
  description "Sends message via telegram"

  env :telegram, [:token, :chat_id]

  type :send_response do
    description "Response from sending a message"
    properties do
      ok :string, "status"
    end
  end

  type :message do
    description "A message to send"
    properties do
      text :string, "The message"
    end
  end

  action :send_message, :message, :send_response, %{text: text} do
    {:ok, res} = Api.send_message(text)
    {:ok, res.body}
  end
end
