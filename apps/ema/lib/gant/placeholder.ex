defmodule Gant.Placeholder do
  use Ema.Service

  name "Json Placeholder"
  description "Get data from the JSON placeholder service"

  defmodule Api do
    @moduledoc false
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
      userId :string, "The user id"
      id :integer, "The post id"
      title :string, "The title of the post"
      body :string, "The body of the post"
    end
  end

  action :get_post, :integer, :post do
    {:ok, res} = Api.get_post(input)
    {:ok, res.body}
  end
end
