defmodule Day4 do
  def solve_part1() do
    136_818..685_979
    |> Enum.reduce(0, fn x, acc ->
      case accept(x) do
        true ->
          acc + 1

        false ->
          acc
      end
    end)
  end

  def solve_part2() do
    136_818..685_979
    |> Enum.reduce(0, fn x, acc ->
      case accept2(x) do
        true ->
          acc + 1

        false ->
          acc
      end
    end)
  end

  def accept(num) do
    accept(num, %{last: nil, two_adj: false, break_order: false})
  end

  def accept(_num, %{last: _last, two_adj: _two_adj, break_order: true}) do
    false
  end

  def accept(num, %{last: last, two_adj: two_adj, break_order: _break_order}) when num > 0 do
    dec = rem(num, 10)
    next_num = div(num, 10)
    is_two_adj = two_adj || dec == last
    break_order = last && dec > last
    accept(next_num, %{last: dec, two_adj: is_two_adj, break_order: break_order})
  end

  def accept(0, %{last: _last, two_adj: two_adj, break_order: break_order}) do
    two_adj && !break_order
  end

  def accept2(num) do
    accept2(num, %{last: nil, two_adj: false, adjs: [], break_order: false})
  end

  def accept2(_num, %{last: _last, two_adj: _two_adj, adjs: _adjs, break_order: true}) do
    false
  end

  def accept2(num, %{
        last: last,
        two_adj: two_adj,
        adjs: adjs,
        break_order: _break_order
      })
      when num > 0 do
    dec = rem(num, 10)
    next_num = div(num, 10)
    is_two_adj = two_adj || dec == last

    adjs =
      case is_two_adj && dec == last do
        true -> [dec | adjs]
        false -> adjs
      end

    break_order = last && dec > last
    accept2(next_num, %{last: dec, two_adj: is_two_adj, adjs: adjs, break_order: break_order})
  end

  def accept2(0, %{last: _last, two_adj: two_adj, adjs: adjs, break_order: break_order}) do
    has_exactly_two_adjacent =
      adjs
      |> Enum.reduce(%{}, fn x, acc ->
        acc |> Map.update(x, 1, fn y -> y + 1 end)
      end)
      |> Enum.find_value(fn {_k, v} -> v == 1 end)

    two_adj && !break_order && has_exactly_two_adjacent != nil
  end
end
