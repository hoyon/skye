defmodule Ema.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Ema.Server,
      :poolboy.child_spec(:ema, poolboy_config())
    ]

    opts = [strategy: :one_for_one, name: Ema.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp poolboy_config do
    [
      {:name, {:local, :ema}},
      {:worker_module, Ema.ScriptSupervisor},
      {:size, 5},
      {:max_overflow, 2}
    ]
  end
end
