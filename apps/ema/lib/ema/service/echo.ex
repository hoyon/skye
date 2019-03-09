defmodule Ema.Service.Echo do
  use Ema.Service

  name "Echo service"
  description "Returns the input string unchanged"

  type :message do
    description "A message"
    properties do
      text :string, "The string to echo"
    end
  end

  action :echo, :message, :message, %{text: text} do
    {:ok, %{text: text}}
  end
end
