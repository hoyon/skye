# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :lana,
  namespace: Lana

# Configures the endpoint
config :lana, Lana.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "T0zAONh5VuE59PCc5jTVEJFsSXG8gTOYsD8C1xfWNfVHutAYW43PI+sl+1weO0DF",
  render_errors: [view: Lana.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Lana.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
