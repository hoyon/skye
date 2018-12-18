defmodule Gant.Echo do
  use Ema.Service

  name "Echo service"
  description "Returns the input string unchanged"

  action :echo, :string, :string do
    {:ok, input}
  end
end
