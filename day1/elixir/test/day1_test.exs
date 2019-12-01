defmodule Day1Test do
  use ExUnit.Case

  test "Day1.solve returns sum of fuel" do
    input = [12, 14, 1969, 100_756]
    assert(Day1.solve(input) == 34241)
  end
end
