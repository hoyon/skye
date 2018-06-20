defmodule Skye.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      Skye.Repo
    ]

    opts = [strategy: :one_for_one, name: Skye.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
