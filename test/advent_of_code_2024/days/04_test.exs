defmodule AdventOfCode2024.Days.Day04Test do
  use ExUnit.Case

  alias AdventOfCode2024.Days.Day04

  describe("Day 4") do
    setup do
      %{input: Day04.get_input()}
    end

    test "part 1", %{input: input} do
      assert Day04.part1(input) == 18
    end

    test "part 2", %{input: input} do
      assert Day04.part2(input) == 9
    end
  end
end
