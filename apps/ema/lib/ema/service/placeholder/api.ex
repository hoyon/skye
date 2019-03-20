defmodule Ema.Service.Placeholder.Api do
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
