defmodule Lana.WebhookController do
  use Lana, :controller

  def run(conn, %{"service" => service, "trigger" => trigger}) do
    service = Map.get(list_triggers(), service)

    if service && trigger in service.triggers do
      Ema.Service.run_trigger(service.module, String.to_existing_atom(trigger), conn.params)

      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(204, "")
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
    |> Enum.reject(&(elem(&1, 1) == []))
    |> Enum.map(fn {service, triggers} ->
      downcased =
        service
        |> Module.split()
        |> List.last()
        |> String.downcase()

      trigger_names =
        triggers
        |> Enum.map(fn {name, _} -> Atom.to_string(name) end)

      {downcased, %{module: service, triggers: trigger_names}}
    end)
    |> Enum.into(%{})
  end
end
