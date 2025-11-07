defmodule ZoiDefstruct.MixProject do
  use Mix.Project

  def project do
    [
      app: :zoi_defstruct,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:zoi, "~> 0.8"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false, warn_if_outdated: true}
    ]
  end

  defp package do
    [
      name: :zoi_defstruct,
      description: "A library for defining structs using Zoi",
      licenses: ["Apache-2.0"],
      source_url: "https://github.com/wingyplus/zoi_defstruct",
      links: %{"GitHub" => "https://github.com/wingyplus/zoi_defstruct"}
    ]
  end
end
