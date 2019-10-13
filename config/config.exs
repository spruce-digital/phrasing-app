# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :phrasing,
  ecto_repos: [Phrasing.Repo]

# Configures the endpoint
config :phrasing, PhrasingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "R93tTU757Tq4XmqJ2ZiuHPlTakIlpWUB9ptbCAMacQDSaiJ3U9lx2ibo1dUxtDwX",
  render_errors: [view: PhrasingWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Phrasing.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "3vLEv4KpFMASLYNMFlY3RL7OWEiZtdQexUWFwSetof3b8VurBO9U1JR7myLpQmUd"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Poison for JSON parsing in Phoenix and Ecto
config :phoenix, :json_library, Poison
config :postgrex, :json_library, Poison

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
