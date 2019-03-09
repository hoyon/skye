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

  scope "/", Lana do
    pipe_through :api

    post "/send-message", PageController, :send_message
    post "/echo", PageController, :echo
  end
end
