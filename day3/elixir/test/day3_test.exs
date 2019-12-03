defmodule Day3Test do
  use ExUnit.Case

  # test "find crossing" do
  #   input1 = ["R8", "U5", "L5", "D3"]
  #   input2 = ["U7", "R6", "D4", "L4"]
  #   crossings = Day3.find_crossings(input1, input2)

  #   assert crossings == [[3, 3], [5, 6]]
  # end

  test "expand coordinates" do
    input = ["R2"]
    coordinates = Day3.expand_coordinates([0, 0], input)
    assert coordinates == [[0, 0], [0, 1], [0, 2]]
  end
end
