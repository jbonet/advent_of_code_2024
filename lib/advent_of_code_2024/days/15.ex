defmodule AdventOfCode2024.Days.Day15 do
  use AdventOfCode2024.Puzzle

  def part1({{grid, width, height}, moveset}) do
    starting_position = find_starting_position(grid)

    grid
    |> apply_moveset(moveset, starting_position)
    |> Stream.filter(fn {_, cell} -> cell == "O" end)
    |> Stream.map(fn {{x, y}, _} -> 100 * y + x end)
    |> Enum.sum()
  end

  def part2({{grid, width, height}, moveset}) do
    grid
    |> expand_warehouse()
    |> print_grid({width * 2, height})
  end

  defp find_starting_position(grid) do
    grid |> Enum.find(fn {_, cell} -> cell == "@" end) |> elem(0)
  end

  defp expand_warehouse(grid) do
    Enum.reduce(grid, %{}, fn {{x, y}, value}, acc ->
      modify = [{2 * x, y}, {2 * x + 1, y}]
      expanded = case value do
        "#" -> ["#", "#"]
        "O" -> ["[", "]"]
        "@" -> ["@", "."]
        "." -> [".", "."]
      end

      expanded
      |> Enum.zip(modify)
      |> Enum.reduce(acc, fn {new_value, new_position}, acc -> Map.put(acc, new_position, new_value) end)
    end)
  end

  defp apply_moveset(grid, [], position), do: grid

  defp apply_moveset(grid, [current_move | moveset], position) do
    # IO.puts("Moving #{current_move} from #{inspect(position)}")
    {grid, new_position} = move(grid, current_move, position)

    # print_grid(grid, {8, 8})

    apply_moveset(grid, moveset, new_position)
  end

  defp move(grid, current_move, {x, y} = current_position) do
    {vx, vy} = get_vector(current_move)

    adjacent_position = {ax, ay} = {x + vx, y + vy}

    # TODO: Check next position: if its a wall, dont move.
    # If its a box, push it if possible.

    case grid[adjacent_position] do
      "#" ->
        # It's a wall, don't move
        # IO.puts("Hit a wall!")
        {grid, current_position}

      "." ->
        # It's empty, move and free the current space
        # IO.puts("Can move! Lets go to #{inspect(adjacent_position)}}!")
        grid =
          grid
          |> Map.put(adjacent_position, "@")
          |> Map.put(current_position, ".")

        {grid, adjacent_position}

      obstacle ->
        # Obstacle. Check if we can push it

        if current_move in ["<", ">"] do
          case get_next_free_or_wall(grid, {x, y}, {vx, vy}, []) do
            {:free, next_position, positions} ->

              grid =
                positions
                |> Enum.reduce(grid, fn new_obstacle_position, acc ->
                  Map.put(acc, new_obstacle_position, "O")
                end)
                |> Map.put(adjacent_position, "@")
                |> Map.put(current_position, ".")

              {grid, adjacent_position}

            {:wall, next_position, _} ->
              {grid, current_position}
          end
        else
          IO.puts("Vertical move, needs a bit of work here :)")
          {grid, current_position}
        end
    end
  end

  defp get_next_free_or_wall(grid, {x, y}, {vx, vy}, positions) do
    next_position = {x + vx, y + vy}
    positions = [next_position | positions]

    case grid[next_position] do
      "." -> {:free, next_position, positions}
      "#" -> {:wall, next_position, positions}
      _ -> get_next_free_or_wall(grid, next_position, {vx, vy}, positions)
    end
  end

  defp print_grid(grid, {width, height}) do
    for y <- 0..(height - 1) do
      for x <- 0..(width - 1) do
        IO.write(grid[{x, y}])
      end

      IO.puts("")
    end
  end

  defp get_vector("^"), do: {0, -1}
  defp get_vector(">"), do: {1, 0}
  defp get_vector("<"), do: {-1, 0}
  defp get_vector("v"), do: {0, 1}
  defp get_vector(_), do: nil

  def parse_input(input) do
    [warehouse, moveset] =
      input
      |> Stream.map(&String.trim/1)
      |> Stream.chunk_by(fn x -> x == "" end)
      |> Stream.reject(fn x -> x == [""] end)
      |> Enum.to_list()

    warehouse =
      warehouse
      |> Stream.with_index()
      |> Enum.reduce({%{}, 0, 0}, fn {row_content, row_i}, acc ->
        {updated_grid, updated_width, _} =
          row_content
          |> String.split("", trim: true)
          |> Enum.with_index()
          |> Enum.reduce(acc, fn {cell_content, col_i}, {current_grid, _, current_height} ->
            current_grid = Map.put(current_grid, {col_i, row_i}, cell_content)

            {current_grid, col_i, current_height}
          end)

        {updated_grid, updated_width + 1, row_i + 1}
      end)

    moveset = Enum.flat_map(moveset, &String.split(&1, "", trim: true))

    {warehouse, moveset}
  end
end
