defmodule Day6Test do
  use ExUnit.Case

  test "parse" do
    assert(Day6.parse("aaa)bbb") == ["aaa", "bbb"])
  end

  test "preprocess input" do
    input = ["aaa)bbb", "bbb)ccc", "ccc)ddd", "eee)fff"]

    assert(
      Day6.preprocess_input(input) == %{
        "aaa" => %{parent: nil, all_parents_count: nil},
        "bbb" => %{parent: "aaa", all_parents_count: nil},
        "ccc" => %{parent: "bbb", all_parents_count: nil},
        "ddd" => %{parent: "ccc", all_parents_count: nil},
        "eee" => %{parent: nil, all_parents_count: nil},
        "fff" => %{parent: "eee", all_parents_count: nil}
      }
    )
  end

  test "solve" do
    input = ["aaa)bbb", "bbb)ccc", "ccc)ddd", "eee)fff"]
    children_lookup = Day6.preprocess_input(input)

    assert(
      Day6.solve(children_lookup) == %{
        children_lookup: %{
          "aaa" => %{parent: nil, all_parents_count: 0},
          "bbb" => %{parent: "aaa", all_parents_count: 1},
          "ccc" => %{parent: "bbb", all_parents_count: 2},
          "ddd" => %{parent: "ccc", all_parents_count: 3},
          "eee" => %{parent: nil, all_parents_count: 0},
          "fff" => %{parent: "eee", all_parents_count: 1}
        },
        count: 7
      }
    )
  end

  test "solve2" do
    input = [
      "COM)BBB",
      "BBB)CCC",
      "CCC)DDD",
      "DDD)EEE",
      "EEE)FFF",
      "BBB)GGG",
      "GGG)HHH",
      "DDD)III",
      "EEE)JJJ",
      "JJJ)KKK",
      "KKK)LLL"
    ]

    children_lookup = Day6.preprocess_input(input)

    assert(
      Day6.solve(children_lookup) == %{
        children_lookup: %{
          "COM" => %{parent: nil, all_parents_count: 0},
          "BBB" => %{parent: "COM", all_parents_count: 1},
          "CCC" => %{parent: "BBB", all_parents_count: 2},
          "DDD" => %{parent: "CCC", all_parents_count: 3},
          "EEE" => %{parent: "DDD", all_parents_count: 4},
          "FFF" => %{parent: "EEE", all_parents_count: 5},
          "GGG" => %{parent: "BBB", all_parents_count: 2},
          "HHH" => %{parent: "GGG", all_parents_count: 3},
          "III" => %{parent: "DDD", all_parents_count: 4},
          "JJJ" => %{parent: "EEE", all_parents_count: 5},
          "KKK" => %{parent: "JJJ", all_parents_count: 6},
          "LLL" => %{parent: "KKK", all_parents_count: 7}
        },
        count: 42
      }
    )
  end
end
