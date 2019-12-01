defmodule Day1Test do
  use ExUnit.Case

  test "Day1.solve returns sum of fuel" do
    input = [12, 14, 1969, 100_756]
    assert(Day1.sum_of_fuel(input, 0) == 34241)
  end

  test "Day1.solve2 returns sum of fuel" do
    assert(Day1.sum_of_fuel_fuel([1969], 0) == 966)
    assert(Day1.sum_of_fuel_fuel([100_756], 0) == 50346)
    assert(Day1.sum_of_fuel_fuel([1969, 100_756], 0) == 51312)
  end
end
