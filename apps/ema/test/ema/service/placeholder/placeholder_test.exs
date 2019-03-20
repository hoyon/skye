defmodule Ema.Service.PlaceholderTest do
  use Ema.ServiceCase, async: true, service: Ema.Service.Placeholder

  import Tesla.Mock
  import Mox

  @base_url Ema.Service.Placeholder.env_base_url()

  setup :verify_on_exit!

  setup_all do
    Mox.defmock(Ema.Service.Placeholder.Api.Mock, for: Tesla.Adapter)
    :ok
  end

  setup do
    Ema.Service.Placeholder.Api.Mock
    |> stub(:call, fn
      %{url: "#{@base_url}/posts/1"}, _opts ->
        {:ok, json(%{"userId" => 1, "id" => 1, "title" => "a post", "body" => "some text"})}

      %{url: "#{@base_url}/users/1"}, _opts ->
        {:ok, json(%{"id" => 1, "name" => "Bob", "username" => "bobby3"})}
    end)

    :ok
  end

  test_action(
    :get_user,
    %{"user_id" => 1},
    %{"name" => "Bob", "username" => "bobby3"}
  )

  test_action(
    :get_post,
    %{"post_id" => 1},
    %{"user_id" => 1, "id" => 1, "title" => "a post", "body" => "some text"}
  )
end
