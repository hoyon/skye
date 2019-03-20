defmodule Ema.Service.Placeholder.Http do
  use Tesla

  @behaviour Ema.Service.Placeholder.Api

  plug(Tesla.Middleware.BaseUrl, Ema.Service.Placeholder.env_base_url())
  plug(Tesla.Middleware.JSON)

  def get_post(id) do
    {:ok, res} = get("/posts/#{id}")

    body = res.body

    {:ok,
     %{
       "user_id" => body["userId"],
       "id" => body["id"],
       "title" => body["title"],
       "body" => body["body"]
     }}
  end

  def get_user(id) do
    {:ok, res} = get("/users/#{id}")

    body = res.body

    {:ok, %{"name" => body["name"], "username" => body["username"]}}
  end
end
