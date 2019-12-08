defmodule Day6 do
  def get_input do
    {:ok, result} = File.read("input.txt")

    String.split(result, [",", "\n"], trim: true)
  end

  def solve_both_parts() do
    children_lookup = preprocess_input(get_input())
    %{children_lookup: children_lookup, count: count} = solve(children_lookup)
    IO.puts("COUNT = #{count}")
    distance(children_lookup, "YOU", "SAN")
  end

  def preprocess_input(input) do
    input
    |> Enum.reduce(%{}, fn line, acc ->
      [parent, child] = parse(line)

      acc =
        case acc[parent] do
          nil ->
            acc
            |> Map.put(parent, %{
              self: parent,
              parent: nil,
              all_parents_count: nil,
              all_parents: []
            })

          _ ->
            acc
        end

      acc
      |> Map.put(child, %{
        self: child,
        parent: parent,
        all_parents_count: nil,
        all_parents: [parent]
      })
    end)
  end

  def solve(children_lookup) do
    children = children_lookup |> Map.keys()

    children
    |> Enum.reduce(%{children_lookup: children_lookup, count: 0}, fn child, acc ->
      child_data = acc[:children_lookup][child]

      # IO.puts("CHILD = #{child}")

      %{parent_count: parent_count, all_parents: all_parents} =
        fill_meta(child_data, acc[:children_lookup], %{
          parent_count: 0,
          all_parents: child_data[:all_parents]
        })

      # IO.puts("CHILD = #{child}, all parrents = #{inspect(all_parents)}")

      child_data =
        child_data
        |> Map.put(:all_parents_count, parent_count)
        |> Map.put(:all_parents, all_parents)

      # IO.puts("CHILD data= #{inspect(child_data)}")
      # IO.puts("\t================")
      # IO.puts("\n\n")

      children_lookup = acc[:children_lookup] |> Map.put(child, child_data)

      acc
      |> Map.put(:count, acc[:count] + parent_count)
      |> Map.put(:children_lookup, children_lookup)
    end)
  end

  def parse(<<n1::binary-size(3)>> <> ")" <> <<n2::binary-size(3)>>) do
    [n1, n2]
  end

  def fill_meta(
        %{self: _self, parent: nil, all_parents_count: _all_parents_count},
        _children_lookup,
        %{
          parent_count: parent_count,
          all_parents: all_parents
        }
      ) do
    # IO.puts("\tRoot")
    # IO.puts(":: Fill #{self}")

    # %{parent_count: parent_count, all_parents: [self | all_parents]}
    %{parent_count: parent_count, all_parents: all_parents}
  end

  def fill_meta(
        %{self: _self, parent: parent, all_parents_count: nil} = _current,
        children_lookup,
        %{
          parent_count: parent_count,
          all_parents: all_parents
        }
      ) do
    next = children_lookup[parent]
    # IO.puts("\tON_THE_PATH")

    # IO.puts("\t\t current: #{inspect(current)}")

    # IO.puts("\t\t next: #{inspect(next)}")

    fill_meta(next, children_lookup, %{
      parent_count: parent_count + 1,
      all_parents:
        [next[:parent] | all_parents] |> Enum.reject(fn x -> is_nil(x) end) |> Enum.dedup()
    })
  end

  def fill_meta(
        %{self: _self, parent: parent, all_parents_count: count, all_parents: cached_all_parents} =
          _current,
        children_lookup,
        %{
          parent_count: parent_count,
          all_parents: all_parents
        }
      ) do
    _next = children_lookup[parent]
    # IO.puts("\tCACHED")

    # IO.puts("\t\t current: #{inspect(current)}")

    # IO.puts("\t\t next: #{inspect(next)}")

    %{
      parent_count: parent_count + count,
      all_parents: (cached_all_parents ++ all_parents) |> Enum.dedup()
    }
  end

  def distance(children_lookup, n1, n2) do
    n1_node = children_lookup[n1]
    n2_node = children_lookup[n2]
    parent1 = children_lookup[n1_node[:parent]]
    parent2 = children_lookup[n2_node[:parent]]
    IO.puts("n 1 = #{inspect(n1_node)}")
    IO.puts("n 2 = #{inspect(n2_node)}")
    IO.puts("parent 1 = #{inspect(parent1)}")
    IO.puts("parent 2 = #{inspect(parent2)}")
    closest_common_p = closest_common_parent(parent1[:all_parents], parent2[:all_parents], nil)
    IO.puts("Closest common parent = #{closest_common_p}")
    closest_common_parent_node = children_lookup[closest_common_p]
    IO.puts("Closest common parent node = #{inspect(closest_common_parent_node)}")

    distance_between =
      parent1[:all_parents_count] - closest_common_parent_node[:all_parents_count] +
        (parent2[:all_parents_count] - closest_common_parent_node[:all_parents_count])

    IO.puts("DESIRED DISTANCE = #{distance_between}")
  end

  def closest_common_parent([parent1 | rest1], [parent2 | rest2], _acc) when parent1 == parent2 do
    closest_common_parent(rest1, rest2, parent1)
  end

  def closest_common_parent([parent1 | _rest1], [parent2 | _rest2], acc)
      when parent1 != parent2 do
    acc
  end
end
