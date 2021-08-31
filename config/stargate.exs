use Mix.Config

config :logger, level: :info
config :astra,
  host: System.get_env("STARGATE_HOST"),
  username: System.get_env("STARGATE_USERNAME"),
  password: System.get_env("STARGATE_PASSWORD")
