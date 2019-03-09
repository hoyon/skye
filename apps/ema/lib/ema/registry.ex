defmodule Ema.Registry do
  use GenServer

  ## API

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def status do
    GenServer.call(__MODULE__, :status)
  end

  def reload do
    GenServer.cast(__MODULE__, :reload)
  end

  def all_services do
    get_services()
  end

  ## Callback

  def init(_) do
    table = :ets.new(:service_registry, [:set, :protected])
    add_services(table)
    {:ok, %{table: table}}
  end

  def handle_call(:status, _from, %{table: table} = state) do
    {:reply, :ets.tab2list(table), state}
  end

  def handle_cast(:reload, %{table: table} = state) do
    :ets.delete_all_objects(table)
    add_services(table)
    {:noreply, state}
  end

  ## Private functions

  defp add_services(table) do
    get_services()
    |> Enum.each(fn service ->
      Ema.Service.init(service)
      :ets.insert(table, {service, Ema.Service.actions(service), Ema.Service.metadata(service)})
    end)
  end

  defp get_services do
    {:ok, mods} = :application.get_key(:ema, :modules)

    Enum.filter(mods, & Ema.Service.is_service?(&1))
  end
end
