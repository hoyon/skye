defmodule Ema.Service.Echo do
  use Ema.Service

  @input %{
    message: :string
  }

  @response %{
    message: :string
  }

  def init(_) do
    {:ok, %{}}
  end

  action :echo, @input, @response do
    {:ok, args}
  end

end
