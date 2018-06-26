defmodule Ema.Server do
  use GenServer

  # API
  def start_link([]) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # Callbacks
  def init(:ok) do
    {:ok, %{}}
  end
end
