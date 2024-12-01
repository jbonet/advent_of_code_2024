defmodule AdventOfCode2024.Application do
  use Application

  require Logger

  def start(_type, _args) do
    Logger.info("Running AdventOfCode 2024!")

    {opts, _, _} =
      OptionParser.parse(System.argv(),
        switches: [all: :boolean, real: :boolean]
      )

    {run_mode, use_sample_data?} = parse_options(opts)

    Application.put_env(:advent_of_code_2024, :sample_data, use_sample_data?)

    AdventOfCode2024.Runner.run(run_mode)

    children = []
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  defp parse_options(opts) do
    sample? = !Keyword.get(opts, :real, false)
    run_mode = if Keyword.get(opts, :all, false), do: :all, else: :today

    {run_mode, sample?}
  end
end
