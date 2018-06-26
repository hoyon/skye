defmodule Ema.ServiceRegistry do
  @moduledoc
  """
  Module which keeps track of all services which Ema can use
  """

  use GenServer

  ## API

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def status do
    GenServer.call(__MODULE__, :status)
  end

  def all_services do
    get_services
  end

  ## Callback

  def init(_) do
    table = :ets.new(:service_registry, [:set, :protected])

    get_services()
    |> Enum.each(fn service ->
      :ets.insert(table, {service, Ema.Service.actions(service)})
    end)
    {:ok, %{table: table}}
  end

  def handle_call(:status, _from,  %{table: table} = state) do
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
