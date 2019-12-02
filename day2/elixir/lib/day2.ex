defmodule Day2 do

  def get_input do
    {:ok, result} = File.read("input.txt")

    String.split(result, [",", "\n"], trim: true)
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def restore_program_state(input) do
    input |> List.replace_at(1, 12) |> List.replace_at(2, 2)
  end

  def solve_part1() do
    input = get_input() |> restore_program_state()
    [ans| _] = do_solve_part1(input, 1, input)
    IO.puts "Answer = #{ans}"
    ans
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
