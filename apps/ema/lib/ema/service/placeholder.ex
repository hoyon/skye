defmodule Ema.Service.Placeholder do
  use Ema.Service

  name "Json Placeholder"
  description "Get data from the JSON placeholder service"
  env :placeholder, [:base_url]

  defmodule Api do
    use Tesla

    plug(Tesla.Middleware.BaseUrl, Ema.Service.Placeholder.env_base_url())
    plug(Tesla.Middleware.JSON)

    def get_post(id) do
      get("/posts/#{id}")
    end

    def get_user(id) do
      get("/users/#{id}")
    end
  end

  type :post, "A post" do
    user_id :integer, "The user id"
    id :integer, "The post id"
    title :string, "The title of the post"
    body :string, "The body of the post"
  end

  type :user do
    name :string
    username :string
  end

  type :get_post_params do
    post_id :integer
  end

  type :get_user_params do
    user_id :integer
  end

  action :get_post, :get_post_params, :post, %{"post_id" => post_id} do
    {:ok, res} = Api.get_post(post_id)
    body = res.body

    {:ok,
     %{
       "user_id" => body["userId"],
       "id" => body["id"],
       "title" => body["title"],
       "body" => body["body"]
     }}
  end

  action :get_user, :get_user_params, :user, %{"user_id" => user_id} do
    {:ok, res} = Api.get_user(user_id)
    body = res.body

    {:ok, %{"name" => body["name"], "username" => body["username"]}}
  end
end
