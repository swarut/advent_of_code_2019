defmodule Day3Test do
  use ExUnit.Case

  test "expands coordinates" do
    input = ["R2"]
    start_point = [0, 0]
    coordinates = Day3.expand_coordinates(input, start_point, [start_point])
    assert coordinates == [[0, 0], [1, 0], [2, 0]]
  end

  test "sample1" do
    input1 = ["R8", "U5", "L5", "D3"]
    input2 = ["U7", "R6", "D4", "L4"]
    assert(Day3.solve(input1, input2, fn {[x, y], _v} -> abs(x) + abs(y) end) == 6)
  end

  test "sample2" do
    input1 = ["R75", "D30", "R83", "U83", "L12", "D49", "R71", "U7", "L72"]
    input2 = ["U62", "R66", "U55", "R34", "D71", "R55", "D58", "R83"]
    assert(Day3.solve(input1, input2, fn {[x, y], _v} -> abs(x) + abs(y) end) == 159)
  end

  test "sample3" do
    input1 = ["R98", "U47", "R26", "D63", "R33", "U87", "L62", "D20", "R33", "U53", "R51"]
    input2 = ["U98", "R91", "D20", "R16", "D67", "R40", "U7", "R15", "U6", "R7"]
    assert(Day3.solve(input1, input2, fn {[x, y], _v} -> abs(x) + abs(y) end) == 135)
  end
end
