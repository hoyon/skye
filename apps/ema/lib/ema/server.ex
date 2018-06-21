defmodule Ema.Server do
  use GenServer

  # API
  def start_link([]) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def hello do
    GenServer.call(__MODULE__, :hello)
  end

  def yo do
    GenServer.cast(__MODULE__, :yo)
  end

  # Callbacks
  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call(:hello, _from, state) do
    res = transaction_call(:hello)

    {:reply, res, state}
  end

  def handle_cast(:yo, state) do
    transaction_cast(:hello)
    {:noreply, state}
  end

  defp transaction_call(args) do
    :poolboy.transaction(
      :ema,
      fn pid -> pid |> Ema.ScriptSupervisor.get_server() |> GenServer.call(args) end
    )
  end

  defp transaction_cast(args) do
    Task.start_link(fn ->
      :poolboy.transaction(
        :ema,
        fn pid ->
          IO.inspect(pid)
          pid |> Ema.ScriptSupervisor.get_server() |> GenServer.call(args)
        end
      )
    end)
  end
end
