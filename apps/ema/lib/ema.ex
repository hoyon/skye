defmodule Ema do
  def titles do
    1..20
    |> Enum.map(fn n -> Honeydew.async({:run, ["#{n}"]}, :ema, reply: true) end)
    |> Enum.map(fn j -> Honeydew.yield(j) end)
  end
end
