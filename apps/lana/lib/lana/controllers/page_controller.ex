defmodule Lana.PageController do
  use Lana, :controller

  def send_message(conn, %{"message" => message}) do
    {:ok, res} = Ema.run_sync(Ema.Service.Telegram, :send_message, message)
    json(conn, res)
  end

  def echo(conn, %{"message" => message}) do
    {:ok, res} = Ema.run_sync(Ema.Service.Echo, :echo, message)
    json(conn, res)
  end

end
