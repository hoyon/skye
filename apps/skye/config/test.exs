use Mix.Config

config :skye, Skye.Repo,
  database: "skye_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
