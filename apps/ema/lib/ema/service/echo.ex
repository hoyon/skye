defmodule Ema.Service.Echo do
  use Ema.Service

  @input %{
    message: :string
  }

  @output %{
    message: :string
  }

  action :echo, @input, @output do
    {:ok, args}
  end

  def init(_) do
    {:ok, %{}}
  end

end
