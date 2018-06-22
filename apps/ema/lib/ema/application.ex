defmodule Ema.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Ema.Server,
      Ema.ServiceRegistry,
      Honeydew.queue_spec(:ema),
      Honeydew.worker_spec(:ema, {Ema.Worker, []}, num: 5, init_retry_secs: 10)
    ]

    opts = [strategy: :one_for_one, name: Ema.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
