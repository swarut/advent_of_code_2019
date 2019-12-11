defmodule Day5 do
  def get_input do
    {:ok, result} = File.read("input.txt")

    String.split(result, [",", "\n"], trim: true)
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def solve_part1()  do
    input = get_input()
    [[result | _rest], _] = process(preprocess_input(input), input, 0, [])
    IO.puts("Result = #{result}")
    result
  end

  # Preprocess input by converting the first item in the list from integer to list of digit.
  def preprocess_input(input) do
    [head | rest] = input
    instruction = normalize_instruction(head)
    IO.puts("INSTRUCTION = #{inspect(instruction)}")
    [instruction | rest]
  end

  def normalize_instruction(n) do
    [100, 10, 10, 10]
    |> Enum.reduce(%{num: n, list: []}, fn i, acc ->
      acc
      |> Map.put(:list, [rem(acc[:num], i) | acc[:list]])
      |> Map.put(:num, div(acc[:num], i))
    end)
    |> Map.get(:list)
  end

  # Position mode
  def get_value(0, input, kv) do
    input |> Enum.at(kv)
  end

  # Immediate mode
  def get_value(1, _input, kv) do
    kv
  end

  def process([[_m3, m2, m1, 1], p1, p2, p3 | _rest], memory, last_cursor, acc) do
    s = get_value(m1, memory, p1) + get_value(m2, memory, p2)
    memory = memory |> List.replace_at(p3, s)
    last_cursor = last_cursor + 4

    process(
      preprocess_input(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      acc
    )
  end

  def process([[_m3, m2, m1, 2], p1, p2, p3 | _rest], memory, last_cursor, acc) do
    s = get_value(m1, memory, p1) * get_value(m2, memory, p2)
    memory = memory |> List.replace_at(p3, s)
    last_cursor = last_cursor + 4

    process(
      preprocess_input(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      acc
    )
  end

  def process([[_m3, m2, m1, 5], p1, p2 | _rest], memory, last_cursor, acc) do
    last_cursor = case get_value(m1, memory, p1) do
      0 -> last_cursor + 3
      _ -> get_value(m2, memory, p2)
    end
    process(
      preprocess_input(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      acc
    )
  end

  def process([[_m3, m2, m1, 6], p1, p2 | _rest], memory, last_cursor, acc) do
    last_cursor = case get_value(m1, memory, p1) do
      0 -> get_value(m2, memory, p2)
      _ -> last_cursor + 3
    end

    process(
      preprocess_input(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      acc
    )
  end

  def process([[_m3, m2, m1, 7], p1, p2, p3 | _rest], memory, last_cursor, acc) do
    s1 = get_value(m1, memory, p1)
    s2 = get_value(m2, memory, p2)

    memory =
      cond do
        s1 < s2 -> memory |> List.replace_at(p3, 1)
        true -> memory |> List.replace_at(p3, 0)
      end

    last_cursor = last_cursor + 4

    process(
      preprocess_input(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      acc
    )
  end

  def process([[_m3, m2, m1, 8], p1, p2, p3 | _rest], memory, last_cursor, acc) do
    s1 = get_value(m1, memory, p1)
    s2 = get_value(m2, memory, p2)

    memory =
      cond do
        s1 == s2 -> memory |> List.replace_at(p3, 1)
        true -> memory |> List.replace_at(p3, 0)
      end

    last_cursor = last_cursor + 4

    process(
      preprocess_input(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      acc
    )
  end

  def process([[_m3, _m2, _m1, 3], p1 | _rest], memory, last_cursor, acc) do
    val = IO.gets("Please input a number:") |> String.trim() |> String.to_integer()
    memory = memory |> List.replace_at(p1, val)
    last_cursor = last_cursor + 2

    process(
      preprocess_input(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      acc
    )
  end

  def process([[_m3, _m2, _m1, 4], p1 | _rest], memory, last_cursor, acc) do
    acc = [memory |> Enum.at(p1) | acc]
    last_cursor = last_cursor + 2

    process(
      preprocess_input(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      acc
    )
  end

  def process([[_m3, _m2, _m1, 99] | _rest], memory, _last_cursor, acc) do
    [acc, memory]
  end
end
