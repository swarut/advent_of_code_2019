defmodule Day6 do
  def get_input do
    {:ok, result} = File.read("input.txt")

    String.split(result, [",", "\n"], trim: true)
  end

  def solve_part1() do
    children_lookup = preprocess_input(get_input())
    solve(children_lookup)
  end

  def preprocess_input(input) do
    input
    |> Enum.reduce(%{}, fn line, acc ->
      [parent, child] = parse(line)

      acc =
        case acc[parent] do
          nil ->
            acc |> Map.put(parent, %{parent: nil, all_parents_count: nil})

          _ ->
            acc
        end

      acc |> Map.put(child, %{parent: parent, all_parents_count: nil})
    end)
  end

  def solve(children_lookup) do
    children = children_lookup |> Map.keys()

    children
    |> Enum.reduce(%{children_lookup: children_lookup, count: 0}, fn child, acc ->
      child_data = acc[:children_lookup][child]
      parent_count = count_parent(child_data, acc[:children_lookup], 0)
      child_data = child_data |> Map.put(:all_parents_count, parent_count)
      children_lookup = acc[:children_lookup] |> Map.put(child, child_data)

      acc
      |> Map.put(:count, acc[:count] + parent_count)
      |> Map.put(:children_lookup, children_lookup)
    end)
  end

  def parse(<<n1::binary-size(3)>> <> ")" <> <<n2::binary-size(3)>>) do
    [n1, n2]
  end

  def count_parent(%{parent: nil, all_parents_count: _all_parents_count}, _children_lookup, acc) do
    acc
  end

  def count_parent(%{parent: parent, all_parents_count: nil}, children_lookup, acc) do
    count_parent(children_lookup[parent], children_lookup, acc + 1)
  end

  def count_parent(%{parent: _parent, all_parents_count: count}, _children_lookup, acc) do
    count + acc
  end
end
