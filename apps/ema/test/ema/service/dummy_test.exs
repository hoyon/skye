defmodule Ema.Service.DummyTest do
  use Ema.ServiceCase, async: true, service: Ema.Service.Dummy

  test_action_type(:echo, %{"text" => "hello"})
  test_action_type(:greet, %{"name" => "bob"})

  describe "echo" do
    test "returns the input string" do
      assert {:ok, %{"text" => "hello"}} =
               Ema.Service.run(Ema.Service.Dummy, :echo, %{"text" => "hello"})
    end
  end

  describe "greet" do
    test "returns greeting" do
      assert {:ok, %{"text" => "Hello bob!"}} =
               Ema.Service.run(Ema.Service.Dummy, :greet, %{"name" => "bob"})
    end
  end
end
