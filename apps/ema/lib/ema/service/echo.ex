defmodule Ema.Service.Echo do
  use Ema.Service

  name "Echo service"
  description "Returns the input string unchanged"

  @input %{
    message: :string
  }

  @output %{
    message: :string
  }

  action :echo, @input, @output do
    {:ok, args}
  end
end
