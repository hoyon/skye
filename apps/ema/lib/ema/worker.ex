defmodule Ema.Worker do
  @behaviour Honeydew.Worker

  def run(service, action, argument) do
    Ema.Service.run(service, action, argument)
  end
end
