defmodule Lana.WebhookPlug do
  import Plug.Conn

  @behaviour Plug

  @impl true
  def init(opts) do
    opts
  end

  @impl true
  def call(conn, _opts) do
    [service, trigger] = conn.path_info

    if triggers = Map.get(list_triggers(), service) do
      if trigger in triggers do
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(200, trigger)
      else
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(404, "Webhook not defined")
      end
    else
      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(404, "Webhook not defined")
    end
  end

  def list_triggers do
    # TODO cache this + only iterate list once
    Ema.Registry.list_services()
    |> Enum.map(fn {service, data} -> {service, data.triggers} end)
    |> Enum.reject(& elem(&1, 1) == [])
    |> Enum.map(fn {service, triggers} ->
      downcased =
        service
        |> Module.split()
        |> List.last()
        |> String.downcase()

      trigger_names =
        triggers
        |> Enum.map(fn {name, _} -> Atom.to_string(name)end)

      {downcased, trigger_names}
    end)
    |> Enum.into(%{})
  end
end
