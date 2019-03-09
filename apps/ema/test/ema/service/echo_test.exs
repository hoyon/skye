defmodule Ema.Service.EchoTest do
  use Ema.ServiceCase, async: true, service: Ema.Service.Echo

  test_action_type(:echo, "hello")

  describe "echo" do
    test "returns the input string" do
      assert {:ok, "hello"} = Ema.Service.run(Ema.Service.Echo, :echo, "hello")
    end
  end

end
