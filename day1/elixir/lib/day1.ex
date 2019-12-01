defmodule Day1 do
  def get_input do
    {:ok, result} = File.read("input.txt")

    String.split(result, "\n", trim: true)
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def solve_part1() do
    sum_of_fuel(get_input(), 0)
  end

  def sum_of_fuel([module | rest], fuel_sum) do
    fuel = floor(module / 3) - 2
    sum_of_fuel(rest, fuel_sum + fuel)
  end

  def sum_of_fuel([], fuel_sum) do
    fuel_sum
  end

  def solve_part2() do
    sum_of_fuel_fuel(get_input(), 0)
  end

  def sum_of_fuel_fuel([module | rest], fuel_sum) when module > 0 do
    next_fuel =
      case floor(module / 3) - 2 do
        n when n > 0 -> n
        _ -> 0
      end

    sum_of_fuel_fuel([next_fuel | rest], fuel_sum + next_fuel)
  end

  def sum_of_fuel_fuel([module | rest], fuel_sum) when module <= 0 do
    sum_of_fuel_fuel(rest, fuel_sum)
  end

  def sum_of_fuel_fuel([], fuel_sum) do
    fuel_sum
  end
end
