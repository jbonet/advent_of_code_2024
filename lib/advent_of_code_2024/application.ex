defmodule AdventOfCode2024.Application do
  use Application

  require Logger

  def start(_type, _args) do
    Logger.info("Running AdventOfCode 2024!")

    if Application.get_env(:advent_of_code_2024, :run) do
      run_mode = Application.get_env(:advent_of_code_2024, :run_mode)
      AdventOfCode2024.Runner.run(run_mode)
    end

    children = []
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
