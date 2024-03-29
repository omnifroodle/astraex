# Astra

An elixir plugin for interacting with DataStax Astra or any stargate.io fronted storage!

Currently supports
  - REST API
  - Document API
  - GraphQL
  - Some Schema API funcitons

## Installation

The package can be installed
by adding `astra` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:astra, "~> 0.1.0"}
  ]
end
```

To connect to Astra add something like the following to your `config.exs`.

For username and password authentication:

```elixir
config :astra,
  id: System.get_env("ASTRA_ID"), #this is your astra cluster id
  region: System.get_env("ASTRA_REGION"), #this is the region where your astra cluster is hosted
  username: System.get_env("ASTRA_USERNAME"),
  password: System.get_env("ASTRA_PASSWORD")
```

For static application tokens:

```elixir
config :astra,
  id: System.get_env("ASTRA_ID"), #this is your astra cluster id
  region: System.get_env("ASTRA_REGION"), #this is the region where your astra cluster is hosted
  application_token: System.get_env("ASTRA_APPLICATION_TOKEN") # this is and application security token for your database
```

For non-astra stargate backends replace `id` and `region` in the config with the stargate `host`, example:

```elixir
config :astra,
  host: my.stargate.endpoint,
  username: System.get_env("ASTRA_USERNAME"),
  password: System.get_env("ASTRA_PASSWORD")