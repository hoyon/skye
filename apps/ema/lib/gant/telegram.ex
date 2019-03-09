defmodule Gant.Telegram do
  use Ema.Service

  name "Telegram"
  description "Sends message via telegram"

  defmodule Api do
    use Tesla

    @token Application.get_env(:ema, :telegram)[:token]
    @chat_id Application.get_env(:ema, :telegram)[:chat_id]

    plug(Tesla.Middleware.BaseUrl, "https://api.telegram.org/bot#{@token}")
    plug(Tesla.Middleware.JSON)

    def send_message(message) do
      post("/sendMessage", %{"chat_id" => @chat_id, "text" => message})
    end
  end

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
