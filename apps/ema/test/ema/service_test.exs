defmodule Ema.ServiceTest do
  use ExUnit.Case, async: true

  describe "metadata" do
    defmodule Metadata do
      use Ema.Service

      name "a service"
      description "a description"
    end

    test "creates function marking it as a service" do
      assert Metadata.__ema_service()
    end

    test "name macro generates function" do
      assert Metadata.__ema_name() == "a service"
    end

    test "description macro generates function" do
      assert Metadata.__ema_description() == "a description"
    end
  end

  describe "actions" do
    defmodule Actions do
      use Ema.Service

      action :echo, :string, :string, %{input: input} do
        {:ok, input}
      end
    end

    test "creates action function with input parameters" do
      assert Actions.action(:echo, %{input: "hello"}) == {:ok, "hello"}
    end

    test "creates function which contains type information" do
      assert Actions.__ema_action_echo() == %{action: :echo, input: :string, output: :string}
    end
  end

  describe "triggers" do
    defmodule Triggers do
      use Ema.Service

      trigger :event, :string, %{request: request} do
        {:ok, request}
      end
    end

    test "creates trigger function with input parameters" do
      assert Triggers.trigger(:event, %{request: "something happened"}) == {:ok, "something happened"}
    end

    test "creates function containing type infomation" do
      assert Triggers.__ema_trigger_event() == %{trigger: :event, output: :string}
    end
  end

  describe "initialisation" do
    defmodule Init do
      use Ema.Service

      env :service3, [:name]
    end

    test "defines env check function" do
      Application.put_env(:ema, :service3, name: "bob")
      assert :ok == Init.__ema_env_check()
    end

    test "without env defined check function raises" do
      Application.put_env(:ema, :service3, nil)

      assert_raise RuntimeError, fn ->
        Init.__ema_env_check()
      end
    end

    test "defines function to get env variable" do
      Application.put_env(:ema, :service3, name: "bob")
      assert Init.env_name() == "bob"
    end
  end
end
