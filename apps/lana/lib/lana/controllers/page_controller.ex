defmodule Lana.PageController do
  use Lana, :controller

  def index(conn, _params) do
    render conn, "index.html", output: ""
  end

  def create(conn, %{"id" => id}) do
    {:ok, title} = Ema.run_service(Placeholder, :get_post, String.to_integer(id))
    |> Ema.yield_result()
    render conn, "index.html", output: title
  end
end
