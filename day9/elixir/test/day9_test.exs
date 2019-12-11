defmodule Day9Test do
  use ExUnit.Case

  # test "normalize instruction" do
  #   assert(Day9.normalize_instruction(1) == [0, 0, 0, 1])
  #   assert(Day9.normalize_instruction(2) == [0, 0, 0, 2])
  #   assert(Day9.normalize_instruction(3) == [0, 0, 0, 3])
  #   assert(Day9.normalize_instruction(4) == [0, 0, 0, 4])
  #   assert(Day9.normalize_instruction(99) == [0, 0, 0, 99])

  #   assert(Day9.normalize_instruction(101) == [0, 0, 1, 1])
  #   assert(Day9.normalize_instruction(1101) == [0, 1, 1, 1])
  #   assert(Day9.normalize_instruction(11101) == [1, 1, 1, 1])
  #   assert(Day9.normalize_instruction(10101) == [1, 0, 1, 1])
  #   assert(Day9.normalize_instruction(11001) == [1, 1, 0, 1])
  #   assert(Day9.normalize_instruction(10001) == [1, 0, 0, 1])

  #   assert(Day9.normalize_instruction(11099) == [1, 1, 0, 99])
  #   assert(Day9.normalize_instruction(11199) == [1, 1, 1, 99])
  #   assert(Day9.normalize_instruction(10199) == [1, 0, 1, 99])
  #   assert(Day9.normalize_instruction(11099) == [1, 1, 0, 99])
  #   assert(Day9.normalize_instruction(10099) == [1, 0, 0, 99])
  # end

  # test "preprocess input" do
  #   assert(Day9.preprocess_instruction([101, 1, 1]) == [[0, 0, 1, 1], 1, 1])
  #   assert(Day9.preprocess_instruction([10099, 3, 4]) == [[1, 0, 0, 99], 3, 4])
  # end

  # test "process" do
  #   input = [1, 0, 0, 0, 99]
  #   pp = Day9.preprocess_instruction(input)
  #   assert(Day9.process(pp, input, 0, %{offset: 0}, []) == [[], [2, 0, 0, 0, 99]])
  # end

  # test "process2" do
  #   input = [2, 3, 0, 3, 99]
  #   pp = Day9.preprocess_instruction(input)
  #   assert(Day9.process(pp, input, 0, %{offset: 0}, []) == [[], [2, 3, 0, 6, 99]])
  # end

  # test "process3" do
  #   input = [5, 10, 3, 4, 4, 2, 99]
  #   pp = Day9.preprocess_instruction(input)

  #   assert(
  #     Day9.process(pp, input, 0, %{offset: 0}, []) == [[3], [5, 10, 3, 4, 4, 2, 99, 0, 0, 0, 0]]
  #   )
  # end

  # test "process4" do
  #   input = [9, 1, 201, 1, 2, 0, 4, 0, 99]
  #   pp = Day9.preprocess_instruction(input)

  #   assert(
  #     Day9.process(pp, input, 0, %{offset: 0}, []) == [[402], [402, 1, 201, 1, 2, 0, 4, 0, 99]]
  #   )
  # end

  # test "program that outputs itself" do
  #   input = [109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99]
  #   pp = Day9.preprocess_instruction(input)

  #   [output, _] = Day9.process(pp, input, 0, %{offset: 0}, [])

  #   assert(output == input)
  # end

  test "program that returns 16-digit number" do
    input = [1102, 34_915_192, 34_915_192, 7, 4, 7, 99, 0]
    pp = Day9.preprocess_instruction(input)
    [[output], _] = Day9.process(pp, input, 0, %{offset: 0}, [])
    output = output |> to_string() |> String.length()
    assert(output == 16)
  end

  test "process7" do
    input = [104, 1_125_899_906_842_624, 99]
    pp = Day9.preprocess_instruction(input)
    [[output], _] = Day9.process(pp, input, 0, %{offset: 0}, [])
    assert(output == 1_125_899_906_842_624)
  end
end
