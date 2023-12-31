# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :soc_ex_api,
  ecto_repos: [SocExApi.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :soc_ex_api, SocExApiWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: SocExApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: SocExApi.PubSub,
  live_view: [signing_salt: "Oe7VtuiJ"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :soc_ex_api, SocExApi.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Use Flop for pagination
config :flop, repo: SocExApi.Repo, default_limit: 10, max_limit: 100

# Configures Guardian for JWT authentication
config :soc_ex_api,
       SocExApi.Guardian,
       issuer: "soc_ex_api",
       ttl: {30, :days},
       secret_key: "some_secret_key"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config("#{config_env()}.exs")
