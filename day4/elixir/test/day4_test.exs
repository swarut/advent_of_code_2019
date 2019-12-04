defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  test "accept" do
    assert(Day4.accept(11) == true)
    assert(Day4.accept(12) == false)
    assert(Day4.accept(122) == true)
    assert(Day4.accept(221) == false)
  end

  test "accept2" do
    assert(Day4.accept2(11) == true)
    assert(Day4.accept2(12) == false)
    assert(Day4.accept2(1223) == true)
    assert(Day4.accept2(1221) == false)
    assert(Day4.accept2(1222) == false)
    assert(Day4.accept2(122_244) == true)
  end
end
