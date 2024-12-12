defmodule AdventOfCode2024.Days.Day12 do
  use AdventOfCode2024.Puzzle

  def part1(input) do
    input
    |> build_adjacency_groups()
    |> IO.inspect(label: "Adjacency!")
    |> calculate_price()
  end

  def part2(input) do
  end

  defp calculate_price(groups) do
    groups
    |> Enum.map(fn group ->
      perimeter =
        group
        |> Enum.map(fn {point, _} -> point end)
        |> calculate_perimeter()

      {group, perimeter}
    end)
    |> Enum.map(fn {group, perimeter} ->
      {_, plant} = Enum.at(group, 0)
      area = MapSet.size(group)

      # IO.puts("A region of #{plant} plants with price #{area} * #{perimeter} = #{area * perimeter}")

      area * perimeter
    end)
    |> Enum.sum()
  end

  defp calculate_perimeter(group) do
    point_set = MapSet.new(group)

    adjacent_offsets = [
      {1, 0},
      {-1, 0},
      {0, 1},
      {0, -1}
    ]

    Enum.reduce(group, 0, fn {px, py}, perimeter ->
      Enum.reduce(adjacent_offsets, perimeter, fn {dx, dy}, acc ->
        adjacent = {px + dx, py + dy}
        if not MapSet.member?(point_set, adjacent), do: acc + 1, else: acc
      end)
    end)
  end

  defp build_adjacency_groups(garden) do
    Enum.reduce(garden, {[], MapSet.new()}, fn {location, plant} = plot, {groups, visited} = acc ->
      if MapSet.member?(visited, plot) do
        IO.puts("ALready visited #{inspect(plot)}")
        acc
      else
        IO.puts("Visiting #{inspect(plot)}")
        group = build_group(garden, plot)

        {[group | groups], MapSet.union(visited, group)}
      end
    end)
  end

  defp build_group(garden, plot) do
    adjacent_plants = get_adjacent_plants_same_species(garden, plot)

    get_next_plant(
      garden,
      MapSet.to_list(adjacent_plants),
      MapSet.new([plot]),
      MapSet.union(adjacent_plants, MapSet.new([plot]))
    )
  end

  defp get_adjacent_plants_same_species(garden, {{x, y}, plant}) do
    adjacent_plants =
      [
        {x + 1, y},
        {x - 1, y},
        {x, y + 1},
        {x, y - 1}
      ]
      |> Enum.reduce(MapSet.new(), fn {nx, ny}, acc ->
        neighbor_plant = Map.get(garden, {nx, ny}, nil)

        if neighbor_plant == plant do
          MapSet.put(acc, {{nx, ny}, neighbor_plant})
        else
          acc
        end
      end)
  end

  defp get_next_plant(_garden, [], already_visited, group), do: group

  defp get_next_plant(garden, [{location, plant} = adjacent_plant | rest], already_visited, group) do
    IO.puts("Visiting #{inspect(adjacent_plant)}")

    {res, already_visited} =
      if MapSet.member?(already_visited, adjacent_plant) do
        IO.puts("Already visited")
        {get_next_plant(garden, rest, already_visited, group), already_visited}
      else
        adjacent = get_adjacent_plants_same_species(garden, adjacent_plant)
        already_visited = MapSet.put(already_visited, adjacent_plant)

        {get_next_plant(
          garden,
          MapSet.to_list(adjacent),
          already_visited,
          MapSet.union(group, adjacent)
        ), already_visited}
      end

    get_next_plant(garden, rest, already_visited, MapSet.union(group, res))
  end

  def parse_input(input) do
    parsed_input =
      input
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.split(&1, "", trim: true))
      |> Enum.to_list()

    IO.puts("Loaded...")

    for {row, row_index} <-
          Enum.with_index(parsed_input, fn element, index -> {element, index} end),
        {element, element_index} <-
          Enum.with_index(row, fn element, index -> {element, index} end),
        into: %{} do
      {{element_index, row_index}, element}
    end
  end
end
