defmodule Ema do
  def run_service(service, function, args) do
    Honeydew.async({:run, [service, function, args]}, :ema, reply: true)
  end

  def yield_result(job) do
    Honeydew.yield(job)
  end

  def run_sync(service, function, args) do
    job = run_service(service, function, args)
    yield_result(job)
  end
end
