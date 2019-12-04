defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  test "accept" do
    assert(Day4.accept(11) == true)
    assert(Day4.accept(12) == false)
    assert(Day4.accept(122) == true)
    assert(Day4.accept(221) == false)
  end
end
