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
end
