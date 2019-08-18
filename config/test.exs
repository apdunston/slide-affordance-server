use Mix.Config

# Configure your database
config :slide_affordance_server, SlideAffordanceServer.Repo,
  username: "postgres",
  password: "postgres",
  database: "slide_affordance_server_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :slide_affordance_server, SlideAffordanceServerWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
