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

  action :send_message, :string, :send_response do
    {:ok, res} = Api.send_message(input)
    {:ok, res.body}
  end
end
