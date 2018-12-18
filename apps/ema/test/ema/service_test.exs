defmodule Ema.ServiceTest do
  use Ema.ServiceCase, async: true, service: Ema.Service.Test

  test_action_type(:echo, "hello")

  describe "Test service" do
    test ":echo returns the input string" do
      assert {:ok, "hello"} = Ema.Service.run(Ema.Service.Test, :echo, "hello")
    end

    test ":echo only accepts a string" do
      assert {:error, _} = Ema.Service.run(Ema.Service.Test, :echo, 1)
    end
  end
end
