defmodule Day2 do
  def get_input do
    {:ok, result} = File.read("input.txt")

    String.split(result, [",", "\n"], trim: true)
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def restore_program_state(input, first_input, second_input) do
    input |> List.replace_at(1, first_input) |> List.replace_at(2, second_input)
  end

  def solve_part1() do
    input = get_input() |> restore_program_state(12, 2)
    [ans | _] = do_solve_part1(input, 1, input)
    IO.puts("Answer = #{ans}")
    ans
  end

  def solve_part2() do
    input = get_input()
    params_pairs = 0..99 |> Enum.flat_map(fn x -> 0..99 |> Enum.map(fn y -> [x, y] end) end)

    params_pairs
    |> Enum.map(fn [x, y] ->
      input = input |> restore_program_state(x, y)
      [ans | _] = do_solve_part1(input, 1, input)

      case ans do
        19_690_720 ->
          IO.puts("[#{x}, #{y}] = #{ans}")

        _ ->
          nil
      end

      ans
    end)
  end

  def do_solve_part1([99 | _rest], _times, all_lines) do
    all_lines
  end

  def do_solve_part1([1, n1, n2, o | _rest], times, all_lines) do
    s = Enum.at(all_lines, n1) + Enum.at(all_lines, n2)
    all_lines = all_lines |> List.replace_at(o, s)
    do_solve_part1(Enum.drop(all_lines, 4 * times), times + 1, all_lines)
  end

  def do_solve_part1([2, n1, n2, o | _rest], times, all_lines) do
    s = Enum.at(all_lines, n1) * Enum.at(all_lines, n2)
    all_lines = all_lines |> List.replace_at(o, s)
    do_solve_part1(Enum.drop(all_lines, 4 * times), times + 1, all_lines)
  end
end
