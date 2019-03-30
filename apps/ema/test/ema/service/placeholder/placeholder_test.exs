defmodule Ema.Service.PlaceholderTest do
  use Ema.ServiceCase, async: true, service: Ema.Service.Placeholder

  setup do
    Ema.Service.Placeholder.MockApi
    |> stub(:get_post, fn _ ->
      {:ok, %{"user_id" => "1", "id" => "1", "title" => "a post", "body" => "some text"} }
    end)
    |> stub(:get_user, fn _ ->
      {:ok, %{"name" => "Bob", "username" => "bobby3"}}
    end)

    :ok
  end

  test_action(
    :get_user,
    %{"user_id" => "1"},
    %{"name" => "Bob", "username" => "bobby3"}
  )

  test_action(
    :get_post,
    %{"post_id" => "1"},
    %{"user_id" => "1", "id" => "1", "title" => "a post", "body" => "some text"}
  )
end
