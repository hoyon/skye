defmodule Ema.Service.TelegramTest do
  use Ema.ServiceCase, async: true, service: Ema.Service.Telegram

  setup do
    Ema.Service.Telegram.MockApi
    |> stub(:send_message, fn message ->
      {:ok, %{"sent_message" => message}}
    end)

    :ok
  end

  test_action(
    :send_message,
    %{"text" => "hello"},
    %{"sent_message" => "hello"}
  )

end
