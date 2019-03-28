use Mix.Config

config :ema, :telegram,
  token: "",
  chat_id: ""

config :ema, :placeholder_api, Ema.Service.Placeholder.MockApi
config :ema, :telegram_api, Ema.Service.Telegram.MockApi
