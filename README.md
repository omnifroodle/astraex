# Astra

An elixir plugin for interacting with DataStax Astra or any stargate.io fronted storage!

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
  id: System.get_env("ASTRA_ID"),
  region: System.get_env("ASTRA_REGION"),
  username: System.get_env("ASTRA_USERNAME"),
  password: System.get_env("ASTRA_PASSWORD")
```
