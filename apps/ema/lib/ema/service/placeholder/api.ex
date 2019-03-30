defmodule Ema.Service.Placeholder.Api do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, Ema.Service.Placeholder.env_base_url())
  plug(Tesla.Middleware.JSON)

  @callback get_post(binary) :: term()
  def get_post(id) do
    {:ok, res} = get("/posts/#{id}")

    body = res.body

    {:ok,
     %{
       "user_id" => body["userId"] |> to_string(),
       "id" => body["id"] |> to_string(),
       "title" => body["title"],
       "body" => body["body"]
     }}
  end

  @callback get_user(binary) :: term()
  def get_user(id) do
    {:ok, res} = get("/users/#{id}")

    body = res.body

    {:ok, %{"name" => body["name"], "username" => body["username"]}}
  end
end
