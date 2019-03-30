defmodule Lana.PageController do
  use Lana, :controller

  def send_message(conn, %{"message" => message}) do
    {:ok, res} = Ema.run_sync(Ema.Service.Telegram, :send_message, %{"text" => message})
    json(conn, res)
  end

  def echo(conn, %{"message" => message}) do
    {:ok, res} = Ema.run_sync(Ema.Service.Dummy, :echo, %{"text" => message})
    json(conn, res)
  end

  def telegram(conn, params) do
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
