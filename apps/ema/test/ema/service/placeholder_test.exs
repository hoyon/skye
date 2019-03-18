defmodule Ema.Service.PlaceholderTest do
  use Ema.ServiceCase, async: true, service: Ema.Service.Placeholder

  import Tesla.Mock

  test_action_type(:get_user, %{"user_id" => 1})
  test_action_type(:get_post, %{"post_id" => 1})

  @base_url Ema.Service.Placeholder.env_base_url()

  setup do
    mock fn
      %{method: :get, url: "#{@base_url}/users/1"} ->
        json(%{"id" => 1, "name" => "Bob", "username" => "bobby3"})

      %{method: :get, url: "#{@base_url}/posts/1"} ->
        json(%{"userId" => 1, "id" => 1, "title" => "a post", "body" => "some text"})
    end

    :ok
  end
end
