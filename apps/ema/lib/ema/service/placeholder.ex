defmodule Ema.Service.Placeholder do
  use Ema.Service

  name "Json Placeholder"
  description "Get data from the JSON placeholder service"

  defmodule Api do
    use Tesla

    plug(Tesla.Middleware.BaseUrl, "https://jsonplaceholder.typicode.com")
    plug(Tesla.Middleware.JSON)

    def get_post(id) do
      get("/posts/#{id}")
    end
  end

  type :post do
    description "A post"
    properties do
      user_id :string, "The user id"
      id :integer, "The post id"
      title :string, "The title of the post"
      body :string, "The body of the post"
    end
  end

  type :get_post_params do
    properties do
      post_id :string, "the post id"
    end
  end

  action :get_post, :get_post_params, :post, %{post_id: post_id} do
    {:ok, res} = Api.get_post(post_id)
    {:ok, res.body}
  end
end
