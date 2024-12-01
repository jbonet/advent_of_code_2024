import Config

config :advent_of_code_2024,
  sample_data: true,
  run_mode: :today

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

import_config "#{config_env()}.exs"
