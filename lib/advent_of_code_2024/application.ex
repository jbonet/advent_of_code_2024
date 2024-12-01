defmodule AdventOfCode2024.Application do
  use Application

  require Logger

  def start(_type, _args) do
    Logger.info("Running AdventOfCode 2024!")

    AdventOfCode2024.Days.One.run() |> IO.inspect(label: "Day 1")

    children = []
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
