defmodule Ema.MixProject do
  use Mix.Project

  def project do
    [
      app: :ema,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.6",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Ema.Application, []}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:honeydew, "~> 1.3"},
      {:tesla, "~> 1.0"},
      {:jason, "~> 1.0"},
      {:nimble_parsec, "~> 0.2"},
      {:mox, "~> 0.5"}
    ]
  end
end
