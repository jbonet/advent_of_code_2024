defmodule AdventOfCode2024.Days.Day10 do
  use AdventOfCode2024.Puzzle

  def part1(input) do
    input
    |> get_trails()
    |> Stream.map(fn x -> MapSet.new(x) end)
    |> Stream.map(fn x -> MapSet.size(x) end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> get_trails()
    |> Stream.map(fn x -> length(x) end)
    |> Enum.sum()
  end

  defp get_trails(input) do
    trailheads = find_trailheads(input)

    input
    |> build_neighbors()
    |> start_trails(trailheads)
  end

  defp find_trailheads(input) do
    Enum.filter(input, fn {_key, value} -> value == 0 end)
  end

  defp build_neighbors(input) do
    Enum.into(input, %{}, fn {key, value} -> {key, get_reachable_neighbors(input, key, value)} end)
  end

  defp get_reachable_neighbors(input, {x, y}, value) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
    |> Enum.reduce(MapSet.new(), fn {nx, ny}, acc ->
      neighbor_value = Map.get(input, {nx, ny}, nil)

      if neighbor_value == value + 1 do
        MapSet.put(acc, {{nx, ny}, neighbor_value})
      else
        acc
      end
    end)
  end

  defp start_trails(neighbors, trailheads) do
    trailheads
    |> Enum.reduce([], fn trailhead, acc ->
      [get_next_trail(neighbors, trailhead) | acc]
    end)
    |> IO.inspect()
  end

  defp get_next_trail_neighbors(_neighbors, [], _trail_ends) do
    []
  end

  defp get_next_trail_neighbors(neighbors, [_ | _] = neighbors_to_check, trail_ends) do
    Enum.reduce(neighbors_to_check, trail_ends, fn point_to_check, acc ->
      acc ++ get_next_trail(neighbors, point_to_check)
    end)
  end

  defp get_next_trail(neighbors, point, trial_ends \\ [])

  defp get_next_trail(_neighbors, {_current_point, 9} = trail_end, trail_ends) do
    [trail_end | trail_ends]
  end

  defp get_next_trail(neighbors, {current_point, _value}, trail_ends) do
    get_next_trail_neighbors(neighbors, MapSet.to_list(neighbors[current_point]), trail_ends)
  end

  def parse_input(input) do
    parsed_input =
      input
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.split(&1, "", trim: true))
      |> Enum.to_list()

    for {row, row_index} <-
          Enum.with_index(parsed_input, fn element, index -> {element, index} end),
        {element, element_index} <-
          Enum.with_index(row, fn element, index -> {element, index} end),
        into: %{} do
      {{element_index, row_index}, String.to_integer(element)}
    end
  end
end
