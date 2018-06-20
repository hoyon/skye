defmodule Lana.PageController do
  use Lana, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
