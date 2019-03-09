defmodule Ema.Service.EchoTest do
  use Ema.ServiceCase, async: true, service: Ema.Service.Echo

  test_action_type(:echo, %{text: "hello"})

  describe "echo" do
    test "returns the input string" do
      assert {:ok, %{text: "hello"}} = Ema.Service.run(Ema.Service.Echo, :echo, %{text: "hello"})
    end
  end

end
