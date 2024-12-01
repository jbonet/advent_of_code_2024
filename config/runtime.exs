import Config

{opts, _, _} =
  OptionParser.parse(System.argv(),
    switches: [all: :boolean, real: :boolean]
  )

config :advent_of_code_2024,
  sample_data: !Keyword.get(opts, :real, false),
  run_mode: if(Keyword.get(opts, :all, false), do: :all, else: :today)
