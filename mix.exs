defmodule Phrasing.MixProject do
  use Mix.Project

  def project do
    [
      app: :phrasing,
      version: "1.1.1",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
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
      mod: {Phrasing.Application, []},
      extra_applications: [:logger, :runtime_tools]
      # applications: [:edeliver],
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bcrypt_elixir, "~> 2.0"},
      {:comeonin, "~> 5.1.3"},
      {:ecto_sql, "~> 3.0"},
      {:ex_machina, "~> 2.3", only: :test},
      {:excheck, "~> 0.6", only: :test},
      {:floki, ">= 0.0.0", only: :test},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.1"},
      {:paasaa, "~> 0.5.0"},
      {:phoenix, "~> 1.4.16"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_html, "~> 2.14"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      # {:phoenix_live_view, github: "phoenixframework/phoenix_live_view"},
      {:phoenix_live_view, "~> 0.11.0"},
      {:phoenix_pubsub, "~> 1.1"},
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 3.1"},
      {:postgrex, ">= 0.0.0"},
      {:sentry, "~> 7.0"},
      {:struct_access, "~> 1.1.2"},
      {:timex, "~> 3.6"},
      {:triq, "~> 1.3", only: [:dev, :test]},
      {:edeliver, "~> 1.8.0"},
      {:distillery, "~> 2.0", warn_missing: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
