use Mix.Config

config :skye, Skye.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "skye_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"
