defmodule Ema.Service.Dummy do
  use Ema.Service

  name "Dummy service"
  description "A dummy service for testing purposes"

  type :message do
    text :string, "The string to echo"
  end

  type :name do
    name :string
  end

  action :echo, :message, :message, %{text: text} do
    {:ok, %{text: text}}
  end

  action :greet, :name, :message, %{name: name} do
    {:ok, %{text: "Hello #{name}!"}}
  end
end
