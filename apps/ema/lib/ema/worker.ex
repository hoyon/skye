defmodule Ema.Worker do
  @behaviour Honeydew.Worker

  def run(service, action, argument) do
    {:ok, result} = Ema.Service.run(service, action, argument)
    result
  end
end
