defmodule Ema.Service.Placeholder do
  use Ema.Service

  name "Json Placeholder"
  description "Get data from the JSON placeholder service"

  defmodule Api do
    use Tesla

    plug(Tesla.Middleware.BaseUrl, "https://jsonplaceholder.typicode.com")
    plug(Tesla.Middleware.JSON)

    def get_post(id) do
      get("/posts/" <> id)
    end
  end

  @post_input %{
    id: :string
  }

  @post_output %{
    userId: :number,
    id: :number,
    title: :string,
    body: :string
  }

  # def action(:get_post, [id], state) do
  #   {:ok, res} = Api.get_post(id)
  #   {:ok, res.body}
  # end

  action :get_post, @post_input, @post_output do
    {:ok, res} = Api.get_post(args.id)
    {:ok, res.body}
  end
end
