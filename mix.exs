defmodule LinkPreviewer.MixProject do
  use Mix.Project

  def project do
    [
      app: :link_previewer,
      dialyzer: dialyzer(),
      version: "0.0.1",
      elixir: "~> 1.7",
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 1.0", only: ~w(dev test)a},
      {:dialyxir, "~> 1.0.0-rc.3", only: ~w(dev test)a, runtime: false},
      {:floki, "~> 0.20.0"},
      {:httpoison, "~> 1.5"}
    ]
  end

  # Dialyzer's configuration
  defp dialyzer do
    [
      flags: ~w(unmatched_returns error_handling race_conditions underspecs unknown)a,
      ignore_warnings: "config/dialyzer.ignore-warnings",
      plt_add_apps: ~w(mix ex_unit)a
    ]
  end
end
