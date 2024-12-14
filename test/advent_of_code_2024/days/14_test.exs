defmodule AdventOfCode2024.Days.Day14Test do
  use ExUnit.Case

  alias AdventOfCode2024.Days.Day14

  describe("Day 14") do
    setup do
      %{input: Day14.get_input()}
    end

    test "part 1", %{input: input} do
      assert Day14.part1(input) == 12
    end

    test "part 2", %{input: input} do
      assert Day14.part2(input) == nil
    end
  end
end
