defmodule Ema.ServiceTest do
  use Ema.ServiceCase, async: true, service: TestService

  test_action_type(:echo, "hello")

  describe "Test service" do
    test ":echo returns the input string" do
      assert {:ok, "hello"} = Ema.Service.run(TestService, :echo, "hello")
    end

    test ":echo only accepts a string" do
      assert {:error, _} = Ema.Service.run(TestService, :echo, 1)
    end
  end
end
