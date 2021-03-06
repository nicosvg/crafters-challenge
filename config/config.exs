# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
#config :craftcha,
#  ecto_repos: [Craftcha.Repo]

# Configures the endpoint
config :craftcha, CraftchaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "72TJQgCWH1vOsDzVjITrDmYnTRGWaio8i5TtqzFP2/ihvJr90SEr8beRhP85TSqJ",
  render_errors: [view: CraftchaWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Craftcha.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure current scenario
config :craftcha, :scenario, Craftcha.Scenario.Ecommerce

# Configure Tesla adapter (http client)
config :tesla, adapter: Tesla.Adapter.Hackney

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
