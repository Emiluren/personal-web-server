# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :chatt_app,
  ecto_repos: [ChattApp.Repo]

# Configures the endpoint
config :chatt_app, ChattApp.Endpoint,
url: [host: "http://www.emiluren.se"],
  secret_key_base: "hh50ZTcyVLDDj1RKbwIBNWCFj0zRlztTmUPp7rAUW6RqS2aYESEOW8xb34M6MSlI",
  render_errors: [view: ChattApp.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ChattApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
