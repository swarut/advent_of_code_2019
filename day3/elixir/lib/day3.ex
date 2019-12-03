defmodule Day3 do
  def get_input do
    {:ok, result} = File.read("input.txt")

    String.split(result, ["\n"], trim: true)
    |> Enum.map(fn line -> line |> String.split([","], trim: true) end)
  end

  def solve_part1() do
    [input1, input2] = get_input()
    s(input1, input2)
  end

  def s(input1, input2) do
    crossings = find_crossing(input1, input2)
    distances = crossings |> Enum.map(fn {[x, y], _v} -> abs(x) + abs(y) end) |> Enum.sort()
    [answer | _] = distances
    answer
  end

  def find_crossing(input1, input2) do
    coordinates1 = expand_coordinates(input1, [0, 0], []) |> Enum.uniq()
    coordinates2 = expand_coordinates(input2, [0, 0], []) |> Enum.uniq()

    plot(coordinates1 ++ coordinates2, %{})
    |> Enum.filter(fn {_k, v} -> v == 2 end)
  end

  def expand_coordinates(["U" <> count | rest], [x, y], acc) do
    count = String.to_integer(count)
    acc = acc ++ (1..count |> Enum.map(fn p -> [x, y + p] end))
    new_start = [x, y + count]
    expand_coordinates(rest, new_start, acc)
  end

  def expand_coordinates(["D" <> count | rest], [x, y], acc) do
    count = String.to_integer(count)
    acc = acc ++ (1..count |> Enum.map(fn p -> [x, y - p] end))
    new_start = [x, y - count]
    expand_coordinates(rest, new_start, acc)
  end

  def expand_coordinates(["R" <> count | rest], [x, y], acc) do
    count = String.to_integer(count)
    acc = acc ++ (1..count |> Enum.map(fn p -> [x + p, y] end))
    new_start = [x + count, y]
    expand_coordinates(rest, new_start, acc)
  end

  def expand_coordinates(["L" <> count | rest], [x, y], acc) do
    count = String.to_integer(count)
    acc = acc ++ (1..count |> Enum.map(fn p -> [x - p, y] end))
    new_start = [x - count, y]
    expand_coordinates(rest, new_start, acc)
  end

  def expand_coordinates([], [_x, _y], acc) do
    acc
  end

  def plot([coordinate | rest], acc) do
    acc = acc |> Map.update(coordinate, 1, fn x -> x + 1 end)
    plot(rest, acc)
  end

  def plot([], acc) do
    acc
  end
end
