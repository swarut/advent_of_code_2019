defmodule Day3 do
  def get_input do
    {:ok, result} = File.read("input.txt")

    String.split(result, [",", "\n"], trim: true)
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def solve_part1() do

  end

  def find_crossing(input1, input2) do
    [input1, input2]
  end

  def expand_coordinates([x, y] = _origin, input) do

  end
end
