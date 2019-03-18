use Mix.Config

config :ema, :telegram,
  token: "",
  chat_id: ""

config :tesla, adapter: Tesla.Mock
