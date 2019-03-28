defmodule Ema.Service.Placeholder do
  use Ema.Service

  @api Application.get_env(:ema, :placeholder_api, Ema.Service.Placeholder.Api)

  name "Json Placeholder"
  description "Get data from the JSON placeholder service"
  env :placeholder, [:base_url]

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
    @api.get_post(post_id)
  end

  action :get_user, :get_user_params, :user, %{"user_id" => user_id} do
    @api.get_user(user_id)
  end
end
