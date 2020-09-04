defmodule Lana.TelegramController do
  use Lana, :controller

  def hook(conn, params) do
    Ema.Service.run_trigger(Ema.Service.Telegram, :got_message, params)
    text = params["message"]["text"]
    if text == "/services" do
      services =
        Ema.Registry.list_services()
        |> Enum.map(& "- #{&1.name}")
        |> Enum.join("\n")
      Ema.run_sync(Ema.Service.Telegram, :send_message, %{"text" => services})
    else
      Ema.run_sync(Ema.Service.Telegram, :send_message, %{"text" => "You said #{text}"})
    end

    send_resp(conn, 200, "")
  end
end
