defmodule Ema.Service.Echo do
  use Ema.Service

  name "Echo service"
  description "Returns the input string unchanged"

  type :message do
    text :string, "The string to echo"
  end

  action :echo, :message, :message, %{text: text} do
    {:ok, %{text: text}}
  end
end
