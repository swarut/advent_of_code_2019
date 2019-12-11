defmodule Day9 do
  def get_instructions do
    {:ok, result} = File.read("input.txt")

    String.split(result, [",", "\n"], trim: true)
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def solve_part1() do
    instructions = get_instructions()

    [[result | _rest], _] =
      process(preprocess_instruction(instructions), instructions, 0, %{offset: 0}, [])

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
    value = memory |> Enum.at(kv)

    case value do
      nil -> {:error, memory, 0, kv}
      _ -> {:ok, memory, value}
    end
  end

  # Immediate mode
  def get_value(1, memory, kv, _options) do
    {:ok, memory, kv}
  end

  # Relative mode
  def get_value(2, memory, kv, %{offset: offset}) do
    value = memory |> Enum.at(offset + kv)

    case value do
      nil -> {:error, memory, 0, offset + kv}
      _ -> {:ok, memory, value}
    end
  end

  def expand_memory_if_needed({:ok, memory, value}) do
    {value, memory}
  end

  def expand_memory_if_needed({:error, memory, value, position}) do
    space_needed = position - length(memory) + 1
    IO.puts("Memory access at #{position}, space_needed = #{space_needed}")
    allocated = List.duplicate(0, space_needed)
    memory = memory ++ allocated
    IO.puts("UPDATED MEMORY = #{inspect(memory)}")
    {value, memory ++ allocated}
  end

  def process(
        [[_m3, _m2, _m1, 9], p1 | _rest],
        memory,
        last_cursor,
        %{offset: offset} = options,
        acc
      ) do
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
    {s1, memory} = get_value(m1, memory, p1, options) |> expand_memory_if_needed()
    {s2, memory} = get_value(m2, memory, p2, options) |> expand_memory_if_needed()
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
    {s1, memory} = get_value(m1, memory, p1, options) |> expand_memory_if_needed()
    {s2, memory} = get_value(m2, memory, p2, options) |> expand_memory_if_needed()
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
    {s, memory} = get_value(m1, memory, p1, options) |> expand_memory_if_needed()

    {last_cursor, memory} =
      case s do
        0 ->
          {last_cursor + 3, memory}

        _ ->
          get_value(m2, memory, p2, options) |> expand_memory_if_needed()
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
    {s, memory} = get_value(m1, memory, p1, options) |> expand_memory_if_needed()

    {last_cursor, memory} =
      case s do
        0 ->
          get_value(m2, memory, p2, options) |> expand_memory_if_needed()

        _ ->
          {last_cursor + 3, memory}
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
    {s1, memory} = get_value(m1, memory, p1, options) |> expand_memory_if_needed()
    {s2, memory} = get_value(m2, memory, p2, options) |> expand_memory_if_needed()

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
    {s1, memory} = get_value(m1, memory, p1, options) |> expand_memory_if_needed()
    {s2, memory} = get_value(m2, memory, p2, options) |> expand_memory_if_needed()

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

  def process([[_m3, _m2, m1, 4], p1 | _rest], memory, last_cursor, options, acc) do
    {s1, memory} = get_value(m1, memory, p1, options) |> expand_memory_if_needed()
    acc = [s1 | acc]
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
    [acc |> Enum.reverse(), memory]
  end
end
