defmodule Day5Test do
  use ExUnit.Case

  test "normalize instruction" do
    assert(Day5.normalize_instruction(1) == [0, 0, 0, 1])
    assert(Day5.normalize_instruction(2) == [0, 0, 0, 2])
    assert(Day5.normalize_instruction(3) == [0, 0, 0, 3])
    assert(Day5.normalize_instruction(4) == [0, 0, 0, 4])
    assert(Day5.normalize_instruction(99) == [0, 0, 0, 99])

    assert(Day5.normalize_instruction(101) == [0, 0, 1, 1])
    assert(Day5.normalize_instruction(1101) == [0, 1, 1, 1])
    assert(Day5.normalize_instruction(11101) == [1, 1, 1, 1])
    assert(Day5.normalize_instruction(10101) == [1, 0, 1, 1])
    assert(Day5.normalize_instruction(11001) == [1, 1, 0, 1])
    assert(Day5.normalize_instruction(10001) == [1, 0, 0, 1])

    assert(Day5.normalize_instruction(11099) == [1, 1, 0, 99])
    assert(Day5.normalize_instruction(11199) == [1, 1, 1, 99])
    assert(Day5.normalize_instruction(10199) == [1, 0, 1, 99])
    assert(Day5.normalize_instruction(11099) == [1, 1, 0, 99])
    assert(Day5.normalize_instruction(10099) == [1, 0, 0, 99])
  end

  test "preprocess input" do
    assert(Day5.preprocess_input([101, 1, 1]) == [[0, 0, 1, 1], 1, 1])
    assert(Day5.preprocess_input([10099, 3, 4]) == [[1, 0, 0, 99], 3, 4])
  end

  test "process" do
    input = [1, 0, 0, 0, 99]
    pp = Day5.preprocess_input(input)
    assert(Day5.process(pp, input, 0, []) == [[], [2, 0, 0, 0, 99]])
  end

  test "process2" do
    input = [2, 3, 0, 3, 99]
    pp = Day5.preprocess_input(input)
    assert(Day5.process(pp, input, 0, []) == [[], [2, 3, 0, 6, 99]])
  end
end
