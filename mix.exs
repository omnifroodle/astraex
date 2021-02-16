defmodule Astra.MixProject do
  use Mix.Project

  def project do
    [
      app: :astra,
      version: "0.3.2",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      description: "REST API adapter for astra.datastax.com and stargate.io",
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  defp docs do
    [
      groups_for_modules: [
        "API": [Astra.Document, Astra.Rest, Astra.Auth],
        "Schema API": [Astra.Schema.Document, Astra.Schema.Rest],
        "Helpers": [Astra.Document.Http, Astra.Rest.Http, Astra.Auth.Http, Astra.Schema.Http]
      ],
      extras: ["README.md", "CHANGELOG.md"],
      main: "readme"
    ]
  end
  
  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => "https://github.com/omnifroodle/astraex"}
    ]
  end
  
  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Astra.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.7"},
      {:elixir_uuid, "~> 1.2"},
      {:jason, "~> 1.0"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
