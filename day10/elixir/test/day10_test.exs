defmodule Day10Test do
  use ExUnit.Case
  doctest Day10

  test "coordinates from line" do
    line = ".###..#"
    assert(Day10.coordinates_from_line(line, 0) == [{0, 1}, {0, 2}, {0, 3}, {0, 6}])
  end

  test "coordinates from lines" do
    lines = [".###..#", "......#"]
    assert(Day10.coordinates_from_lines(lines) == [{0, 1}, {0, 2}, {0, 3}, {0, 6}, {1, 6}])
  end
end
