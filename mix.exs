defmodule SocExApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :soc_ex_api,
      version: "0.1.0",
      name: "soc-ex-api",
      source_url: "https://github.com/gabrielmaialva33/soc-ex-api.git",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {SocExApi.Application, []},
      extra_applications: [:logger, :runtime_tools, :os_mon, :ex_machina]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support", "test/factories"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.7.7"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.10"},
      {:postgrex, "~> 0.17.2"},
      {:phoenix_live_dashboard, "~> 0.8.1"},
      {:swoosh, "~> 1.11.5"},
      {:finch, "~> 0.16"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.23.1"},
      {:jason, "~> 1.4"},
      {:plug_cowboy, "~> 2.6"},
      {:argon2_elixir, "~> 3.1"},
      {:flop, "~> 0.22"},
      {:guardian, "~> 2.3"},
      {:goal, "~> 0.3"},
      # development
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ecto_psql_extras, "~> 0.7.12", only: [:dev, :test]},
      # test
      {:ex_machina, "~> 2.7", only: [:dev, :test]},
      {:faker, "~> 0.17", only: [:dev, :test]}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
