defmodule AdventOfCode2024.Days.Day03Test do
  use ExUnit.Case

  alias AdventOfCode2024.Days.Day03

  describe("Day 3") do
    setup do
      %{input: Day03.get_input()}
    end

    test "part 1", %{input: input} do
      assert Day03.part1(input) == 161
    end

    test "part 2", %{input: input} do
      assert Day03.part2(input) == 48
    end
  end
end
