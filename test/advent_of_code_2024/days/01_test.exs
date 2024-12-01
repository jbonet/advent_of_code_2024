defmodule AdventOfCode2024.Days.Day01Test do
  use ExUnit.Case

  alias AdventOfCode2024.Days.Day01

  test "Day 1" do
    assert Day01.run() == {11, 31}
  end
end
