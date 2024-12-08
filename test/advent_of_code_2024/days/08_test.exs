defmodule AdventOfCode2024.Days.Day08Test do
  use ExUnit.Case

  alias AdventOfCode2024.Days.Day08

  describe("Day 8") do
    setup do
      %{input: Day08.get_input()}
    end

    test "part 1", %{input: input} do
      assert Day08.part1(input) == 14
    end

    test "part 2", %{input: input} do
      assert Day08.part2(input) == 34
    end
  end
end
