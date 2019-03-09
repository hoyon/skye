defmodule Ema.ServiceTest do
  use ExUnit.Case, async: true

  describe "metadata" do
    defmodule Service do
      use Ema.Service

      name "a service"
      description "a description"
    end

    test "creates function marking it as a service" do
      assert Service.__ema_service()
    end

    test "name macro generates function" do
      assert Service.__ema_name() == "a service"
    end

    test "description macro generates function" do
      assert Service.__ema_description() == "a description"
    end
  end

  describe "actions" do
    defmodule Service2 do
      use Ema.Service

      action :echo, :string, :string do
        {:ok, input}
      end
    end

    test "creates action function which exposes input" do
      assert Service2.action(:echo, "hello") == {:ok, "hello"}
    end

    test "creates function which contains type information" do
      assert Service2.__ema_action_echo() == %{action: :echo, input: :string, response: :string}
    end
  end
end
