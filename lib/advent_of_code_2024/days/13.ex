defmodule AdventOfCode2024.Days.Day13 do
  use AdventOfCode2024.Puzzle

  @a_cost 3
  @b_cost 1
  @correction 10_000_000_000_000

  def part1(input) do
    input
    |> Stream.map(&get_cheapest_cost/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Stream.map(fn %{"prize" => {px, py}} = x ->
      %{x | "prize" => {px + @correction, py + @correction}}
    end)
    |> Stream.map(&get_cheapest_cost/1)
    |> Enum.sum()
  end

  defp get_cheapest_cost(%{"A" => {ax, ay}, "B" => {bx, by}, "prize" => {px, py}}) do
    with {a, true} <- calculate_a(px, py, ax, ay, bx, by),
         {b, true} <- calculate_b(px, ax, bx, a) do
      a * @a_cost + b * @b_cost
    else
      _ -> 0
    end
  end

  defp calculate_a(px, py, ax, ay, bx, by) do
    sum = px * -1 * by + py * bx
    a_sum = ax * -1 * by + ay * bx
    a = sum / a_sum
    {a, trunc(a) == a}
  end

  defp calculate_b(px, ax, bx, a) do
    b = (px - ax * a) / bx
    {b, trunc(b) == b}
  end

  def parse_input(input) do
    input
    |> Stream.map(&String.trim/1)
    |> Stream.chunk_by(fn x -> x == "" end)
    |> Stream.reject(fn x -> length(x) < 3 end)
    |> Stream.map(fn x -> Enum.into(x, %{}, &parse_line/1) end)
    |> Enum.to_list()
  end

  defp parse_line(<<"Button "::binary, button::binary-size(1), ": "::binary, coords::binary>>) do
    coords =
      coords
      |> String.split(", ", trim: true)
      |> Enum.map(fn x ->
        [_, value] = String.split(x, "+", trim: true)
        String.to_integer(value)
      end)
      |> List.to_tuple()

    {button, coords}
  end

  defp parse_line(<<"Prize: "::binary, coords::binary>>) do
    coords =
      coords
      |> String.split(", ", trim: true)
      |> Enum.map(fn x ->
        [_, value] = String.split(x, "=", trim: true)
        String.to_integer(value)
      end)
      |> List.to_tuple()

    {"prize", coords}
  end
end
