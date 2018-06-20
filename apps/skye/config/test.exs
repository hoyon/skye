use Mix.Config

config :skye, Skye.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "skye_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
