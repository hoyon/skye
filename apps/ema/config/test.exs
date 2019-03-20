use Mix.Config

config :ema, :telegram,
  token: "",
  chat_id: ""

config :ema, :placeholder,
  adapter: Ema.Service.Placeholder.MockApi
