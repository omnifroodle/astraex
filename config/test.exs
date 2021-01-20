use Mix.Config

config :logger, level: :debug

config :astra,
  id: System.get_env("ASTRA_ID"),
  region: System.get_env("ASTRA_REGION"),
  keyspace: System.get_env("ASTRA_KEYSPACE"),
  username: System.get_env("ASTRA_USERNAME"),
  password: System.get_env("ASTRA_PASSWORD")