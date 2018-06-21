defmodule Ema.ScriptServer do
  use GenServer

  defmodule State do
    defstruct sup: nil
  end

  def start_link([sup]) do
    GenServer.start_link(__MODULE__, sup)
  end

  def init(sup) do
    {:ok, %State{sup: sup}}
  end

  def handle_call(:hello, _from, %{sup: sup} = state) do
    :timer.sleep(1000)
    IO.inspect(sup)
    {:reply, "Supervisor: #{inspect(sup)}", state}
  end

  def handle_cast(:hello, %{sup: sup} = state) do
    IO.puts("start")
    :timer.sleep(1000)
    IO.inspect(sup)
    {:noreply, state}
  end

end
