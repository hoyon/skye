defmodule Ema.Worker do
  @behaviour Honeydew.Worker

  def run(service, action, argument) do
    {:ok, post} = Ema.Service.run(Module.concat(Gant, service), action, argument)
    post["title"]
  end
end
