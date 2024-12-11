defmodule AdventOfCode2024.Days.Day11Test do
  use ExUnit.Case

  alias AdventOfCode2024.Days.Day11

  describe("Day 11") do
    setup do
      %{input: Day11.get_input()}
    end

    test "part 1", %{input: input} do
      assert Day11.part1(input) == 55312
    end

    test "part 2", %{input: input} do
      assert Day11.part2(input) == nil
    end
  end
end
