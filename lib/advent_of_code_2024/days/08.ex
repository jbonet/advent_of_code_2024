defmodule AdventOfCode2024.Days.Day08 do
  use AdventOfCode2024.Puzzle

  def part1({grid, antennas}) do
    antennas
    |> generate_antinodes(grid, false)
    |> MapSet.size()
  end

  def part2({grid, antennas}) do
    res = antennas |> generate_antinodes(grid, true)

    antennas
    |> Enum.reduce(res, fn {_, points}, acc ->
      points
      |> MapSet.new()
      |> MapSet.union(acc)
    end)
    |> MapSet.size()
  end

  def generate_antinodes(antennas, grid, with_harmonics) do
    antennas
    |> Stream.flat_map(fn {antenna, locations} ->
      for location1 <- locations,
          location2 <- locations,
          location1 != location2,
          do: {antenna, location1, location2}
    end)
    |> Enum.reduce(MapSet.new(), fn {_antenna, p1, p2}, acc ->
      grid
      |> do_generate_antinodes(p1, p2, with_harmonics)
      |> Enum.reduce(acc, fn x, acc ->
        maybe_add_antinode(acc, grid, x)
      end)
    end)
  end

  defp point_in_grid?(grid, {x, y}) do
    Map.get(grid, "#{x}-#{y}", nil) != nil
  end

  defp do_generate_antinodes(_grid, {x1, y1} = p1, {x2, y2} = p2, false) do
    {{vx1, vy1}, {vx2, vy2}} = get_vectors(p1, p2)

    [{x1 + vx1, y1 + vy1}, {x2 + vx2, y2 + vy2}]
  end

  defp do_generate_antinodes(grid, p1, p2, true) do
    {v1, v2} = get_vectors(p1, p2)

    [get_next_antinode(grid, p1, v1), get_next_antinode(grid, p2, v2)] |> List.flatten()
  end

  def get_next_antinode(grid, point, vector, results \\ [])

  def get_next_antinode(grid, {x, y}, {vx, vy} = vector, results) do
    next_antinode = {x + vx, y + vy}

    if point_in_grid?(grid, next_antinode) do
      get_next_antinode(grid, next_antinode, vector, [next_antinode | results])
    else
      results
    end
  end

  def get_vectors({x1, y1}, {x2, y2}) do
    {vx, vy} = {abs(x1 - x2), abs(y1 - y2)}

    cond do
      x1 < x2 and y1 < y2 -> {{-1 * vx, -1 * vy}, {vx, vy}}
      x1 > x2 and y1 > y2 -> {{vx, vy}, {-1 * vx, -1 * vy}}
      x1 < x2 and y1 > y2 -> {{-1 * vx, vy}, {vx, -1 * vy}}
      x1 > x2 and y1 < y2 -> {{vx, -1 * vy}, {-1 * vx, vy}}
    end
  end

  defp maybe_add_antinode(antinodes, grid, antinode) do
    if point_in_grid?(grid, antinode), do: MapSet.put(antinodes, antinode), else: antinodes
  end

  defp to_point(point_str) do
    point_str |> String.split("-") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
  end

  def parse_input(input) do
    parsed_input =
      input
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.split(&1, "", trim: true))
      |> Enum.to_list()

    grid =
      for {row, row_index} <-
            Enum.with_index(parsed_input, fn element, index -> {element, index} end),
          {element, element_index} <-
            Enum.with_index(row, fn element, index -> {element, index} end),
          into: %{} do
        {"#{element_index}-#{row_index}", element}
      end

    antennas =
      grid
      |> Enum.reduce(%{}, fn
        {_coords, "."}, acc ->
          acc

        {coords, antenna}, acc ->
          Map.update(acc, antenna, [to_point(coords)], fn x -> [to_point(coords) | x] end)
      end)

    {grid, antennas}
  end
end
