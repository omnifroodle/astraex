# Astra

An elixir plugin for interacting with DataStax Astra or any stargate.io fronted storage!

Currently supports
  - REST API
  - Document API

GraphQL/Schema should be available soon.

To use, setup an Astra instance at https://astra.datastax.com.

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

To connect to Astra add something like the following to your `config.exs`:

```elixir
config :astra,
  id: System.get_env("ASTRA_ID"), #this is your astra cluster id
  region: System.get_env("ASTRA_REGION"), #this is the region where your astra cluster is hosted
  username: System.get_env("ASTRA_USERNAME"),
  password: System.get_env("ASTRA_PASSWORD")
```
