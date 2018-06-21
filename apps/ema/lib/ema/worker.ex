defmodule Ema.Worker do
  @behaviour Honeydew.Worker

  def init(_) do
    {:ok, %{}}
  end

  def run(id, state) do
    {:ok, post} = Ema.Service.run(Ema.Service.Placeholder, :get_post, %{id: id})
    post["title"]
  end
end
