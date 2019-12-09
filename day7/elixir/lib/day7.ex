require Amplifier

defmodule Day7 do
  def solve_part1() do
    signal_permutations = [0, 1, 2, 3, 4] |> permutations

    signal_permutations
    |> Enum.map(fn signals -> execute_phase_setting(signals) end)
    |> Enum.max()
  end

  def execute_phase_setting([p1, p2, p3, p4, p5]) do
    Amplifier.execute([p1, 0])
    |> wrap_amplifier(p2)
    |> wrap_amplifier(p3)
    |> wrap_amplifier(p4)
    |> wrap_amplifier(p5)
  end

  def wrap_amplifier(v, p2) do
    Amplifier.execute([p2, v])
  end

  def permutations([]), do: [[]]

  def permutations(list),
    do: for(elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest])
end
