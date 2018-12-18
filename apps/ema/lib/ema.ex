defmodule Ema do
  def titles do
    1..20
    |> Enum.map(fn n -> Honeydew.async({:run, [Placeholder, :get_post, n]}, :ema, reply: true) end)
    |> Enum.map(fn j -> Honeydew.yield(j) end)
  end

  def run_service(service, function, argument) do
    Honeydew.async({:run, [service, function, argument]}, :ema, reply: true)
  end

  def yield_result(job) do
    Honeydew.yield(job)
  end
end
