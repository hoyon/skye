defmodule Skye.Repo do
  use Ecto.Repo,
    otp_app: :skye,
    adapter: Ecto.Adapters.Postgres
end
