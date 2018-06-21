defmodule Ema.ScriptSupervisor do
  use Supervisor

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg)
  end

  def get_server(pid) do
    pid
    |> Supervisor.which_children
    |> Enum.find(fn {mod, _, _, _} -> mod == Ema.ScriptServer end)
    |> elem(1)
  end

  def init(_arg) do
    children = [
      {Ema.ScriptServer, [self()]}
    ]

    opts = [strategy: :one_for_one]

    Supervisor.init(children, opts)
  end

end
