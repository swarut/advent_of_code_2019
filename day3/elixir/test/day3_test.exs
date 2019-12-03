defmodule Day3Test do
  use ExUnit.Case

  test "expands coordinates" do
    input = ["R2"]
    start_point = [0, 0]
    coordinates = Day3.expand_coordinates(input, start_point, [start_point])
    assert coordinates == [[0, 0], [1, 0], [2, 0]]
  end

  test "wire_distance" do
    input1 = ["R8", "U5", "L5", "D3"]
    start_point = [0, 0]
    coordinates1 = Day3.expand_coordinates(input1, start_point, []) |> Enum.uniq()
    assert(Day3.wire_distance(coordinates1, [8, 0], 0) == 8)
    assert(Day3.wire_distance(coordinates1, [8, 5], 0) == 13)
    assert(Day3.wire_distance(coordinates1, [3, 5], 0) == 18)
  end

  test "part1 sample1" do
    input1 = ["R8", "U5", "L5", "D3"]
    input2 = ["U7", "R6", "D4", "L4"]
    start_point = [0, 0]
    coordinates1 = Day3.expand_coordinates(input1, start_point, []) |> Enum.uniq()
    coordinates2 = Day3.expand_coordinates(input2, start_point, []) |> Enum.uniq()
    assert(Day3.solve(coordinates1, coordinates2, fn {[x, y], _v} -> abs(x) + abs(y) end) == 6)
  end

  test "part1 sample2" do
    input1 = ["R75", "D30", "R83", "U83", "L12", "D49", "R71", "U7", "L72"]
    input2 = ["U62", "R66", "U55", "R34", "D71", "R55", "D58", "R83"]
    start_point = [0, 0]
    coordinates1 = Day3.expand_coordinates(input1, start_point, []) |> Enum.uniq()
    coordinates2 = Day3.expand_coordinates(input2, start_point, []) |> Enum.uniq()
    assert(Day3.solve(coordinates1, coordinates2, fn {[x, y], _v} -> abs(x) + abs(y) end) == 159)
  end

  test "part1 sample3" do
    input1 = ["R98", "U47", "R26", "D63", "R33", "U87", "L62", "D20", "R33", "U53", "R51"]
    input2 = ["U98", "R91", "D20", "R16", "D67", "R40", "U7", "R15", "U6", "R7"]
    start_point = [0, 0]
    coordinates1 = Day3.expand_coordinates(input1, start_point, []) |> Enum.uniq()
    coordinates2 = Day3.expand_coordinates(input2, start_point, []) |> Enum.uniq()
    assert(Day3.solve(coordinates1, coordinates2, fn {[x, y], _v} -> abs(x) + abs(y) end) == 135)
  end

  test "part2 sample1" do
    input1 = ["R8", "U5", "L5", "D3"]
    input2 = ["U7", "R6", "D4", "L4"]
    start_point = [0, 0]
    coordinates1 = Day3.expand_coordinates(input1, start_point, [])
    coordinates2 = Day3.expand_coordinates(input2, start_point, [])

    assert(
      Day3.solve(coordinates1, coordinates2, fn {[x, y], _v} ->
        Day3.track_wire_distance(coordinates1, x, y) +
          Day3.track_wire_distance(coordinates2, x, y)
      end) == 30
    )
  end

  test "part2 sample2" do
    input1 = ["R75", "D30", "R83", "U83", "L12", "D49", "R71", "U7", "L72"]
    input2 = ["U62", "R66", "U55", "R34", "D71", "R55", "D58", "R83"]
    start_point = [0, 0]
    coordinates1 = Day3.expand_coordinates(input1, start_point, [])
    coordinates2 = Day3.expand_coordinates(input2, start_point, [])

    assert(
      Day3.solve(coordinates1, coordinates2, fn {[x, y], _v} ->
        Day3.track_wire_distance(coordinates1, x, y) +
          Day3.track_wire_distance(coordinates2, x, y)
      end) == 610
    )
  end

  test "part2 sample3" do
    input1 = ["R98", "U47", "R26", "D63", "R33", "U87", "L62", "D20", "R33", "U53", "R51"]
    input2 = ["U98", "R91", "D20", "R16", "D67", "R40", "U7", "R15", "U6", "R7"]
    start_point = [0, 0]
    coordinates1 = Day3.expand_coordinates(input1, start_point, [])
    coordinates2 = Day3.expand_coordinates(input2, start_point, [])

    assert(
      Day3.solve(coordinates1, coordinates2, fn {[x, y], _v} ->
        Day3.track_wire_distance(coordinates1, x, y) +
          Day3.track_wire_distance(coordinates2, x, y)
      end) == 410
    )
  end
end
