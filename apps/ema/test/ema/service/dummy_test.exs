defmodule Ema.Service.DummyTest do
  use Ema.ServiceCase, async: true, service: Ema.Service.Dummy

  test_action(:echo, %{"text" => "hello"}, %{"text" => "hello"})
  test_action(:greet, %{"name" => "bob"}, %{"text" => "Hello bob!"})
end
