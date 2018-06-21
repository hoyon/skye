defmodule EmaTest do
  use ExUnit.Case
  doctest Ema

  test "greets the world" do
    assert Ema.hello() == :world
  end
end
