defmodule Day2Test do
  use ExUnit.Case

  test "Day1.solve returns sum of fuel" do
    input = [1, 1, 2, 3, 1, 3, 3, 4, 99, 10, 11, 100]
    input2 = [1,9,10,3,2,3,11,0,99,30,40,50]
    [h1 | _] = Day2.do_solve_part1(input, 1, input)
    [h2 | _] = Day2.do_solve_part1(input2, 1, input2)
    assert(h1 == 1)
    assert(h2 == 3500)

  end
end
