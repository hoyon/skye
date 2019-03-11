defmodule Ema.Service.Dummy do
  use Ema.Service

  name "Dummy service"
  description "A dummy service for testing purposes"

  type :message do
    text :string, "The string to echo"
  end

  action :echo, :message, :message, %{text: text} do
    {:ok, %{text: text}}
  end
end
