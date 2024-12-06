defmodule AdventOfCode2024.Days.Day06Test do
  use ExUnit.Case

  alias AdventOfCode2024.Days.Day06

  describe("Day 6") do
    setup do
      %{input: Day06.get_input()}
    end

    test "part 1", %{input: input} do
      assert Day06.part1(input) == 41
    end

    test "part 2", %{input: input} do
      assert Day06.part2(input) == 6
    end
  end
end
