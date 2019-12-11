defmodule Day9 do
  def get_instructions do
    {:ok, result} = File.read("input.txt")

    String.split(result, [",", "\n"], trim: true)
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def solve_part1()  do
    instructions = get_instructions()
    [[result | _rest], _] = process(preprocess_instruction(instructions), instructions, 0, %{offset: 0}, [])
    IO.puts("Result = #{result}")
    result
  end

  # Preprocess input by converting the first item in the list from integer to list of digit.
  def preprocess_instruction(instructions) do
    [head | rest] = instructions
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
  def get_value(0, memory, kv, _options) do
    {:ok, memory |> Enum.at(kv)}
  end

  # Immediate mode
  def get_value(1, _memory, kv, _options) do
    {:ok, kv}
  end

  # Relative mode
  def get_value(2, memory, kv, %{offset: offset}) do
    {:ok, memory |> Enum.at(offset + kv)}
  end

  def process([[_m3, _m2, _m1, 9], p1 | _rest], memory, last_cursor, %{offset: offset} = options, acc) do
    options = options |> Map.put(:offset, offset + p1)
    last_cursor = last_cursor + 2

    process(
      preprocess_instruction(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      options,
      acc
    )
  end

  def process([[_m3, m2, m1, 1], p1, p2, p3 | _rest], memory, last_cursor, options, acc) do
    {:ok, s1} = get_value(m1, memory, p1, options)
    {:ok, s2} = get_value(m2, memory, p2, options)
    s = s1 + s2
    memory = memory |> List.replace_at(p3, s)
    last_cursor = last_cursor + 4

    process(
      preprocess_instruction(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      options,
      acc
    )
  end

  def process([[_m3, m2, m1, 2], p1, p2, p3 | _rest], memory, last_cursor, options, acc) do
    {:ok, s1} = get_value(m1, memory, p1, options)
    {:ok, s2} = get_value(m2, memory, p2, options)
    s = s1 * s2
    memory = memory |> List.replace_at(p3, s)
    last_cursor = last_cursor + 4

    process(
      preprocess_instruction(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      options,
      acc
    )
  end

  def process([[_m3, m2, m1, 5], p1, p2 | _rest], memory, last_cursor, options, acc) do
    {:ok, s} = get_value(m1, memory, p1, options)
    last_cursor = case s do
      0 -> last_cursor + 3
      _ ->
        {:ok, l} = get_value(m2, memory, p2, options)
        l
    end
    process(
      preprocess_instruction(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      options,
      acc
    )
  end

  def process([[_m3, m2, m1, 6], p1, p2 | _rest], memory, last_cursor, options, acc) do
    {:ok, s} = get_value(m1, memory, p1, options)
    last_cursor = case s do
      0 ->
        {:ok, l} = get_value(m2, memory, p2, options)
        l
      _ -> last_cursor + 3
    end

    process(
      preprocess_instruction(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      options,
      acc
    )
  end

  def process([[_m3, m2, m1, 7], p1, p2, p3 | _rest], memory, last_cursor, options, acc) do
    {:ok, s1} = get_value(m1, memory, p1, options)
    {:ok, s2} = get_value(m2, memory, p2, options)

    memory =
      cond do
        s1 < s2 -> memory |> List.replace_at(p3, 1)
        true -> memory |> List.replace_at(p3, 0)
      end

    last_cursor = last_cursor + 4

    process(
      preprocess_instruction(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      options,
      acc
    )
  end

  def process([[_m3, m2, m1, 8], p1, p2, p3 | _rest], memory, last_cursor, options, acc) do
    {:ok, s1} = get_value(m1, memory, p1, options)
    {:ok, s2} = get_value(m2, memory, p2, options)

    memory =
      cond do
        s1 == s2 -> memory |> List.replace_at(p3, 1)
        true -> memory |> List.replace_at(p3, 0)
      end

    last_cursor = last_cursor + 4

    process(
      preprocess_instruction(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      options,
      acc
    )
  end

  def process([[_m3, _m2, _m1, 3], p1 | _rest], memory, last_cursor, options, acc) do
    val = IO.gets("Please input a number:") |> String.trim() |> String.to_integer()
    memory = memory |> List.replace_at(p1, val)
    last_cursor = last_cursor + 2

    process(
      preprocess_instruction(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      options,
      acc
    )
  end

  def process([[_m3, _m2, _m1, 4], p1 | _rest], memory, last_cursor, options, acc) do
    acc = [memory |> Enum.at(p1) | acc]
    last_cursor = last_cursor + 2

    process(
      preprocess_instruction(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      options,
      acc
    )
  end

  def process([[_m3, _m2, _m1, 99] | _rest], memory, _last_cursor, _options, acc) do
    [acc, memory]
  end
end
