defmodule Lana.Router do
  use Lana, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  forward "/api", Absinthe.Plug,
    schema: Lana.Schema,
    json_codec: Jason

  forward "/graphiql", Absinthe.Plug.GraphiQL,
    schema: Lana.Schema,
    json_codec: Jason,
    interface: :playground

  scope "/", Lana do
    pipe_through :api

    post "/webhook/:service/:trigger", WebhookController, :run
    post "/telegram", TelegramController, :hook
  end
end
