defmodule Ema.Application do
  use Application

  def start(_type, _args) do
    children = [
      Ema.Server,
      Ema.Registry,
    ]

    Honeydew.start_queue(:ema)
    Honeydew.start_workers(:ema, Ema.Worker, num: 5, init_retry_secs: 10)

    opts = [strategy: :one_for_one, name: Ema.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
