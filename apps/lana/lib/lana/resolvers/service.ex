defmodule Lana.Resolvers.Service do
  alias Ema.Registry

  def list_services(_, _, _) do
    {:ok, Registry.list_services()}
  end
end
