defmodule Day3 do
  def get_input do
    {:ok, result} = File.read("input.txt")

    String.split(result, ["\n"], trim: true)
    |> Enum.map(fn line -> line |> String.split([","], trim: true) end)
  end

  def solve_part1() do
    [input1, input2] = get_input()
    coordinates1 = expand_coordinates(input1, [0, 0], []) |> Enum.uniq()
    coordinates2 = expand_coordinates(input2, [0, 0], []) |> Enum.uniq()
    solve(coordinates1, coordinates2, fn {[x, y], _v} -> abs(x) + abs(y) end)
  end

  def solve_part2() do
    [input1, input2] = get_input()
    coordinates1 = expand_coordinates(input1, [0, 0], [])
    coordinates2 = expand_coordinates(input2, [0, 0], [])

    solve(coordinates1, coordinates2, fn {[x, y], _v} ->
      track_wire_distance(coordinates1, x, y) + track_wire_distance(coordinates2, x, y)
    end)
  end

  def track_wire_distance(coordinates, x, y) do
    wire_distance(coordinates, [x, y], 0)
  end

  def wire_distance([[x1, y1] | _rest], [target_x, target_y], acc)
      when x1 == target_x and y1 == target_y do
    acc + 1
  end

  def wire_distance([[_x1, _y1] | rest], target, acc) do
    wire_distance(rest, target, acc + 1)
  end

  # Based on this implementation for part2, as there is no duplicate removal for each coordinate set,
  # there can be a chance that the crossing point is not valid (for instance, same point is repeat twice
  # just only by the same wire). A quick hack is to cheat by increasing the wire_distance to large number
  # when we can't really find the target coordinate in a given wire.
  def wire_distance([], _target, _acc) do
    1_000_000
  end

  def solve(coordinates1, coordinates2, distance) do
    crossings = find_crossing(coordinates1, coordinates2)
    distances = crossings |> Enum.map(distance) |> Enum.sort()
    IO.puts("CROSSINGS = #{inspect(crossings)}")
    IO.puts("DISTANCE = #{inspect(distances)}")
    [answer | _] = distances
    answer
  end

  def find_crossing(coordinates1, coordinates2) do
    plot(coordinates1 ++ coordinates2, %{}) |> Enum.filter(fn {_k, v} -> v >= 2 end)
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
