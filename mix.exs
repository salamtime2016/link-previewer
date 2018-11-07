defmodule LinkPreview.MixProject do
  use Mix.Project

  def project do
    [
      app: :link_preview,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
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
      {:credo, "~> 0.10", only: ~w(dev test)a},
      {:dialyxir, "~> 1.0.0-rc.3", only: ~w(dev test)a, runtime: false},
      {:floki, "~> 0.20.0"}
    ]
  end
end
