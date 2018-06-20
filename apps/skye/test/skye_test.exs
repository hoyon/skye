defmodule SkyeTest do
  use ExUnit.Case
  doctest Skye

  test "greets the world" do
    assert Skye.hello() == :world
  end
end
