defmodule Day9 do
  require IEx

  def get_instructions do
    {:ok, result} = File.read("input.txt")

    String.split(result, [",", "\n"], trim: true)
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def solve_part1() do
    instructions = get_instructions()

    p = process(preprocess_instruction(instructions), instructions, 0, %{relative_base: 0}, [])
    [[result | _rest], _] = p

    IO.puts("Result = #{inspect(result)}")
    IO.puts("Result = #{inspect(p)}")
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

  def get_write_position(p1, mode, %{relative_base: relative_base}) do
    case mode do
      0 -> p1
      2 -> p1 + relative_base
    end
  end

  # Position mode
  def get_value(0, memory, kv, _options) do
    value = memory |> Enum.at(kv)

    case value do
      nil -> {:error, memory, kv}
      _ -> {:ok, memory, value}
    end
  end

  # Immediate mode
  def get_value(1, memory, kv, _options) do
    {:ok, memory, kv}
  end

  # Relative mode
  def get_value(2, memory, kv, %{relative_base: relative_base}) do
    value = memory |> Enum.at(relative_base + kv)

    IO.puts(
      "--------------- GETTING mode 2 for kv = #{kv} and relative_base = #{relative_base}, value= #{
        value
      }, memory length = #{length(memory)}"
    )

    case value do
      nil -> {:error, memory, relative_base + kv}
      _ -> {:ok, memory, value}
    end
  end

  def set_value(memory, position, value) do
    IO.puts("\t [set value] #{value} at position #{position}")

    cond do
      position > length(memory) ->
        expand(memory, position)

      true ->
        memory
    end
    |> List.replace_at(position, value)
  end

  def expand(memory, position) do
    IO.puts("\t Expanding memory to position #{position}")
    space_needed = position - length(memory) + 1
    allocated = List.duplicate(0, space_needed)
    memory ++ allocated
  end

  def expand_memory_if_needed({:ok, memory, value}) do
    {value, memory}
  end

  def expand_memory_if_needed({:error, memory, position}) do
    IO.puts("EXPAND MEMORY")
    memory = expand(memory, position)
    {0, memory}
  end

  def log(inst, modes, last_cursor, relative_base) do
    IO.puts("Processing instruction #{inst}::")
    IO.puts(":: Mode: #{modes}")
    IO.puts(":: Last cursor = #{last_cursor}")
    IO.puts(":: relative_base = #{relative_base}")
  end

  def process(
        [[_m3, _m2, m1, 9], p1 | _rest],
        memory,
        last_cursor,
        %{relative_base: relative_base} = options,
        acc
      ) do
    log(9, "m1 = #{m1}", last_cursor, relative_base)
    {s1, memory} = get_value(m1, memory, p1, options) |> expand_memory_if_needed()
    options = options |> Map.put(:relative_base, relative_base + s1)
    IO.puts("\t Param1 = #{p1}, Value1 = #{s1}")
    IO.puts("\t Change relative_base from #{relative_base} to #{relative_base + s1}")
    last_cursor = last_cursor + 2
    IO.puts("================================\n")

    process(
      preprocess_instruction(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      options,
      acc
    )
  end

  def process([[_m3, _m2, m1, 3], p1 | _rest], memory, last_cursor, options, acc) do
    log(3, "m1 = #{m1}", last_cursor, options[:relative_base])
    # {s1, memory} = get_value(m1, memory, p1, options) |> expand_memory_if_needed()
    s1 = get_write_position(p1, m1, options)
    IO.puts("S1 = #{s1}")
    IO.puts("\t Param1 = #{p1}, Value1 = #{s1}")
    val = IO.gets("Please input a number:") |> String.trim() |> String.to_integer()
    memory = memory |> set_value(s1, val)
    last_cursor = last_cursor + 2
    IO.puts("================================\n")

    process(
      preprocess_instruction(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      options,
      acc
    )
  end

  def process([[m3, m2, m1, 1], p1, p2, p3 | _rest], memory, last_cursor, options, acc) do
    log(1, "m1 = #{m1}, m2 = #{m2}", last_cursor, options[:relative_base])
    {s1, memory} = get_value(m1, memory, p1, options) |> expand_memory_if_needed()
    {s2, memory} = get_value(m2, memory, p2, options) |> expand_memory_if_needed()
    s = s1 + s2
    IO.puts("\t Param1 = #{p1}, Value1 = #{s1}")
    IO.puts("\t Param2 = #{p2}, Value2 = #{s2}")
    IO.puts("\t Param3 = #{p3}")
    IO.puts("\t Compute #{s1} + #{s2} = #{s}, then save to slot #{p3}")
    memory = memory |> set_value(get_write_position(p3, m3, options), s)
    last_cursor = last_cursor + 4
    IO.puts("================================\n")

    process(
      preprocess_instruction(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      options,
      acc
    )
  end

  def process([[m3, m2, m1, 2], p1, p2, p3 | _rest], memory, last_cursor, options, acc) do
    log(2, "m1 = #{m1}, m2 = #{m2}", last_cursor, options[:relative_base])
    {s1, memory} = get_value(m1, memory, p1, options) |> expand_memory_if_needed()
    {s2, memory} = get_value(m2, memory, p2, options) |> expand_memory_if_needed()
    s = s1 * s2
    IO.puts("\t Param1 = #{p1}, Value1 = #{s1}")
    IO.puts("\t Param2 = #{p2}, Value2 = #{s2}")
    IO.puts("\t Param3 = #{p3}")
    IO.puts("\t Compute #{s1} * #{s2} = #{s}, then save to slot #{p3}")
    memory = memory |> set_value(get_write_position(p3, m3, options), s)
    last_cursor = last_cursor + 4
    IO.puts("================================\n")

    process(
      preprocess_instruction(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      options,
      acc
    )
  end

  def process([[_m3, m2, m1, 5], p1, p2 | _rest], memory, last_cursor, options, acc) do
    log(5, "m1 = #{m1}, m2 = #{m2}", last_cursor, options[:relative_base])
    {s, memory} = get_value(m1, memory, p1, options) |> expand_memory_if_needed()
    IO.puts("\t Param1 = #{p1}, Value1 = #{s}")
    IO.puts("\t Param2 = #{p2}")
    IO.puts("\t Check if #{s} != 0 or not?")

    {last_cursor, memory} =
      case s do
        0 ->
          IO.puts("\t - #{0} is equal to 0, do nothing")
          {last_cursor + 3, memory}

        _ ->
          IO.puts("\t - #{0} is not equal to 0 jump to next cursor")
          get_value(m2, memory, p2, options) |> expand_memory_if_needed()
      end

    IO.puts("\t Next cursor = #{last_cursor}")
    IO.puts("================================\n")

    process(
      preprocess_instruction(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      options,
      acc
    )
  end

  def process([[_m3, m2, m1, 6], p1, p2 | _rest], memory, last_cursor, options, acc) do
    log(6, "m1 = #{m1}, m2 = #{m2}", last_cursor, options[:relative_base])
    {s, memory} = get_value(m1, memory, p1, options) |> expand_memory_if_needed()
    IO.puts("\t Param1 = #{p1}, Value1 = #{s}")
    IO.puts("\t Param2 = #{p2}")
    IO.puts("\t Check if #{s} == 0 or not?}")

    {last_cursor, memory} =
      case s do
        0 ->
          IO.puts("\t - #{0} is equal to 0, jump to next cursor")
          get_value(m2, memory, p2, options) |> expand_memory_if_needed()

        _ ->
          IO.puts("\t - #{0} is not equal to 0, do nothing")
          {last_cursor + 3, memory}
      end

    IO.puts("================================\n")

    process(
      preprocess_instruction(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      options,
      acc
    )
  end

  def process([[m3, m2, m1, 7], p1, p2, p3 | _rest], memory, last_cursor, options, acc) do
    log(7, "m1 = #{m1}, m2 = #{m2}", last_cursor, options[:relative_base])
    {s1, memory} = get_value(m1, memory, p1, options) |> expand_memory_if_needed()
    {s2, memory} = get_value(m2, memory, p2, options) |> expand_memory_if_needed()
    IO.puts("\t Param1 = #{p1}, Value1 = #{s1}")
    IO.puts("\t Param2 = #{p2}, Value2 = #{s2}")
    IO.puts("\t Param3 = #{p3}")
    IO.puts("\t Check if #{s1} < #{s2} or not")

    memory =
      cond do
        s1 < s2 ->
          IO.puts("\t - #{s1} < #{s2}, store 1 at #{p3}")
          memory |> set_value(get_write_position(p3, m3, options), 1)

        true ->
          IO.puts("\t - #{s1} >= #{s2}, store 0 at #{p3}")
          memory |> set_value(get_write_position(p3, m3, options), 0)
      end

    last_cursor = last_cursor + 4
    IO.puts("================================\n")

    process(
      preprocess_instruction(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      options,
      acc
    )
  end

  def process([[m3, m2, m1, 8], p1, p2, p3 | _rest], memory, last_cursor, options, acc) do
    log(8, "m1 = #{m1}, m2 = #{m2}", last_cursor, options[:relative_base])
    {s1, memory} = get_value(m1, memory, p1, options) |> expand_memory_if_needed()
    {s2, memory} = get_value(m2, memory, p2, options) |> expand_memory_if_needed()
    IO.puts("\t Param1 = #{p1}, Value1 = #{s1}")
    IO.puts("\t Param2 = #{p2}, Value2 = #{s2}")
    IO.puts("\t Param3 = #{p3}")
    IO.puts("\t Check if #{s1} == #{s2} or not, if yes, store 1 at #{p3}")

    memory =
      cond do
        s1 == s2 ->
          IO.puts("\t - #{s1} == #{s2}, store 1 at #{p3}")
          memory |> set_value(get_write_position(p3, m3, options), 1)

        true ->
          IO.puts("\t - #{s1} != #{s2}, store 0 at #{p3}")
          memory |> set_value(get_write_position(p3, m3, options), 0)
      end

    last_cursor = last_cursor + 4
    IO.puts("================================\n")

    process(
      preprocess_instruction(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      options,
      acc
    )
  end

  def process([[_m3, _m2, m1, 4], p1 | _rest], memory, last_cursor, options, acc) do
    log(4, "m1 = #{m1}", last_cursor, options[:relative_base])
    {s1, memory} = get_value(m1, memory, p1, options) |> expand_memory_if_needed()
    IO.puts("\t Param1 = #{p1}, Value1 = #{s1}")
    IO.puts("\t Output  value at slot #{s1}")
    acc = [s1 | acc]
    last_cursor = last_cursor + 2
    IO.puts("================================\n")

    process(
      preprocess_instruction(memory |> Enum.drop(last_cursor)),
      memory,
      last_cursor,
      options,
      acc
    )
  end

  def process([[_m3, _m2, _m1, 99] | _rest], memory, _last_cursor, _options, acc) do
    log(99, "", "", "")
    IO.puts("================================\n")
    [acc |> Enum.reverse(), memory]
  end
end
