# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :slide_affordance_server,
  ecto_repos: [SlideAffordanceServer.Repo]

# Configures the endpoint
config :slide_affordance_server, SlideAffordanceServerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JzTjmq9LRjcltB4+3JMRlmJvs7JVPu4T2HnaySiLqyhfFtHeyujYhxHnK++eyVSV",
  render_errors: [view: SlideAffordanceServerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: SlideAffordanceServer.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "akj4gh43lkajgh43l4ktjha34lgkjhago3iuvbhp9W"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
