use Mix.Config

config :ema, :telegram,
  token: "",
  chat_id: ""

config :tesla, Ema.Service.Placeholder.Api, adapter: Ema.Service.Placeholder.Api.Mock
