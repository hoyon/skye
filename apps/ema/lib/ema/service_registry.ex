defmodule Ema.ServiceRegistry do
  use GenServer

  ## API

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def register(mod, action, input, response) do
    GenServer.cast(__MODULE__, {:register, mod, action, input, response})
  end

  def status do
    GenServer.call(__MODULE__, :status)
  end

  ## Callback

  def init(_) do
    table = :ets.new(:service_registry, [:set, :protected])
    {:ok, %{table: table}}
  end

  def handle_cast({:register, mod, action, input, response}, %{table: table} = state) do
    :ets.insert(table, {{mod, action}, {input, response}})
    {:noreply, state}
  end

  def handle_call(:status, %{table: table} = state) do
    {:reply, :ets.tab2list(table), state}
  end

  ## Private functions

  # Get all modules which are services
  # ie are of form Ema.Service.<something>
  defp get_services do
    {:ok, mods} = :application.get_key(:ema, :modules)
    mods
    |> Enum.filter(fn mod ->
      split = Module.split(mod)
      length(split) == 3 and Enum.take(split, 2) == ["Ema", "Service"]
    end)
  end

end
