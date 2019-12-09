defmodule Amplifier do
  def get_instructions do
    # {:ok, result} = File.read("input2.txt")
    {:ok, result} = File.read("input.txt")

    String.split(result, [",", "\n"], trim: true)
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def execute(pair_of_input_signals) do
    instructions = get_instructions()

    [[result | _rest], _] =
      execute_instructions(
        preprocess_instructions(instructions),
        instructions,
        pair_of_input_signals,
        0,
        []
      )

    # IO.puts("Result = #{result}")
    result
  end

  # Preprocess input by converting the first item in the list from integer to list of digit.
  def preprocess_instructions(instructions) do
    [head | rest] = instructions
    instruction = normalize_instruction(head)
    # IO.puts("INSTRUCTION = #{inspect(instruction)}")
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

  def execute_instructions(
        [[_m3, m2, m1, 1], p1, p2, p3 | _rest],
        instructions,
        pair_of_input_signals,
        last_cursor,
        acc
      ) do
    s = get_value(m1, instructions, p1) + get_value(m2, instructions, p2)
    instructions = instructions |> List.replace_at(p3, s)
    last_cursor = last_cursor + 4

    execute_instructions(
      preprocess_instructions(instructions |> Enum.drop(last_cursor)),
      instructions,
      pair_of_input_signals,
      last_cursor,
      acc
    )
  end

  def execute_instructions(
        [[_m3, m2, m1, 2], p1, p2, p3 | _rest],
        instructions,
        pair_of_input_signals,
        last_cursor,
        acc
      ) do
    s = get_value(m1, instructions, p1) * get_value(m2, instructions, p2)
    instructions = instructions |> List.replace_at(p3, s)
    last_cursor = last_cursor + 4

    execute_instructions(
      preprocess_instructions(instructions |> Enum.drop(last_cursor)),
      instructions,
      pair_of_input_signals,
      last_cursor,
      acc
    )
  end

  def execute_instructions(
        [[_m3, m2, m1, 5], p1, p2 | _rest],
        instructions,
        pair_of_input_signals,
        last_cursor,
        acc
      ) do
    case get_value(m1, instructions, p1) do
      0 ->
        last_cursor = last_cursor + 3

        execute_instructions(
          preprocess_instructions(instructions |> Enum.drop(last_cursor)),
          instructions,
          pair_of_input_signals,
          last_cursor,
          acc
        )

      _ ->
        last_cursor = get_value(m2, instructions, p2)

        execute_instructions(
          preprocess_instructions(instructions |> Enum.drop(last_cursor)),
          instructions,
          pair_of_input_signals,
          last_cursor,
          acc
        )
    end
  end

  def execute_instructions(
        [[_m3, m2, m1, 6], p1, p2 | _rest],
        instructions,
        pair_of_input_signals,
        last_cursor,
        acc
      ) do
    case get_value(m1, instructions, p1) do
      0 ->
        last_cursor = get_value(m2, instructions, p2)

        execute_instructions(
          preprocess_instructions(instructions |> Enum.drop(last_cursor)),
          instructions,
          pair_of_input_signals,
          last_cursor,
          acc
        )

      _ ->
        last_cursor = last_cursor + 3

        execute_instructions(
          preprocess_instructions(instructions |> Enum.drop(last_cursor)),
          instructions,
          pair_of_input_signals,
          last_cursor,
          acc
        )
    end
  end

  def execute_instructions(
        [[_m3, m2, m1, 7], p1, p2, p3 | _rest],
        instructions,
        pair_of_input_signals,
        last_cursor,
        acc
      ) do
    s1 = get_value(m1, instructions, p1)
    s2 = get_value(m2, instructions, p2)

    instructions =
      cond do
        s1 < s2 -> instructions |> List.replace_at(p3, 1)
        true -> instructions |> List.replace_at(p3, 0)
      end

    last_cursor = last_cursor + 4

    execute_instructions(
      preprocess_instructions(instructions |> Enum.drop(last_cursor)),
      instructions,
      pair_of_input_signals,
      last_cursor,
      acc
    )
  end

  def execute_instructions(
        [[_m3, m2, m1, 8], p1, p2, p3 | _rest],
        instructions,
        pair_of_input_signals,
        last_cursor,
        acc
      ) do
    s1 = get_value(m1, instructions, p1)
    s2 = get_value(m2, instructions, p2)

    instructions =
      cond do
        s1 == s2 -> instructions |> List.replace_at(p3, 1)
        true -> instructions |> List.replace_at(p3, 0)
      end

    last_cursor = last_cursor + 4

    execute_instructions(
      preprocess_instructions(instructions |> Enum.drop(last_cursor)),
      instructions,
      pair_of_input_signals,
      last_cursor,
      acc
    )
  end

  def execute_instructions(
        [[_m3, _m2, _m1, 3], p1 | _rest],
        instructions,
        [input_signal | rest_of_pair_of_input_signals],
        last_cursor,
        acc
      ) do
    val = input_signal
    instructions = instructions |> List.replace_at(p1, val)
    last_cursor = last_cursor + 2

    execute_instructions(
      preprocess_instructions(instructions |> Enum.drop(last_cursor)),
      instructions,
      rest_of_pair_of_input_signals,
      last_cursor,
      acc
    )
  end

  def execute_instructions(
        [[_m3, _m2, _m1, 4], p1 | _rest],
        instructions,
        pair_of_input_signals,
        last_cursor,
        acc
      ) do
    acc = [instructions |> Enum.at(p1) | acc]
    last_cursor = last_cursor + 2

    execute_instructions(
      preprocess_instructions(instructions |> Enum.drop(last_cursor)),
      instructions,
      pair_of_input_signals,
      last_cursor,
      acc
    )
  end

  def execute_instructions(
        [[_m3, _m2, _m1, 99] | _rest],
        instructions,
        _pair_of_input_signals,
        _last_cursor,
        acc
      ) do
    [acc, instructions]
  end
end
