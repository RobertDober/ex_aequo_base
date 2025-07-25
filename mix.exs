defmodule ExAequoBase.MixProject do
  use Mix.Project
  @version "0.1.6"
  @url "https://github.com/RobertDober/ex_aequo_base"

  def project do
    [
      app: :ex_aequo_base,
      version: @version,
      elixir: "~> 1.19-rc",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Elixir code I use all over my places",
      package: package(),
      test_coverage: [tool: ExCoveralls],
      aliases: [docs: &build_docs/1]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      # extra_applications: [:logger]
    ]
  end

  def cli do
      [preferred_envs: [coveralls: :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test]]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_aequo_fn, "~> 0.1.3"},
      {:dialyxir, "~> 1.4.5", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.18.5", only: [:test]},
    ]
  end

  defp package do
    [
      files: [
        "lib",
        "mix.exs",
        "README.md",
        "LICENSE"
      ],
      maintainers: [
        "Robert Dober <robert.dober@gmail.com>"
      ],
      licenses: [
        "AGPL-3.0-or-later"
      ],
      links: %{
        "GitHub" => @url
      }
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "examples", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  @module "ExAequoBase"

  defp build_docs(_) do
    Mix.Task.run("compile")
    ex_doc = Path.join(Mix.path_for(:escripts), "ex_doc")
    Mix.shell().info("Using escript: #{ex_doc} to build the docs")

    unless File.exists?(ex_doc) do
      raise "cannot build docs because escript for ex_doc is not installed, " <>
              "make sure to run `mix escript.install hex ex_doc` before"
    end

    args = [@module, @version, Mix.Project.compile_path()]
    opts = ~w[--main #{@module} --source-ref v#{@version} --source-url #{@url}]

    Mix.shell().info("Running: #{ex_doc} #{inspect(args ++ opts)}")
    System.cmd(ex_doc, args ++ opts)
    Mix.shell().info("Docs built successfully")
  end
end

# SPDX-License-Identifier: AGPL-3.0-or-later
