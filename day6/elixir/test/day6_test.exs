defmodule Day6Test do
  use ExUnit.Case

  test "parse" do
    assert(Day6.parse("aaa)bbb") == ["aaa", "bbb"])
  end

  test "preprocess input" do
    input = ["aaa)bbb", "bbb)ccc", "ccc)ddd", "eee)fff"]

    assert(
      Day6.preprocess_input(input) == %{
        "aaa" => %{self: "aaa", parent: nil, all_parents_count: nil, all_parents: []},
        "bbb" => %{self: "bbb", parent: "aaa", all_parents_count: nil, all_parents: ["aaa"]},
        "ccc" => %{self: "ccc", parent: "bbb", all_parents_count: nil, all_parents: ["bbb"]},
        "ddd" => %{self: "ddd", parent: "ccc", all_parents_count: nil, all_parents: ["ccc"]},
        "eee" => %{self: "eee", parent: nil, all_parents_count: nil, all_parents: []},
        "fff" => %{self: "fff", parent: "eee", all_parents_count: nil, all_parents: ["eee"]}
      }
    )
  end

  test "closest common parent" do
    parents1 = ["aaa", "bbb", "ccc1", "ddd1"]
    parents2 = ["aaa", "bbb", "ccc2", "ddd2"]
    assert(Day6.closest_common_parent(parents1, parents2, nil) == "bbb")
  end

  test "solve" do
    input = ["aaa)bbb", "bbb)ccc", "ccc)ddd", "eee)fff"]
    children_lookup = Day6.preprocess_input(input)

    assert(
      Day6.solve(children_lookup) == %{
        children_lookup: %{
          "aaa" => %{self: "aaa", parent: nil, all_parents_count: 0, all_parents: []},
          "bbb" => %{self: "bbb", parent: "aaa", all_parents_count: 1, all_parents: ["aaa"]},
          "ccc" => %{
            self: "ccc",
            parent: "bbb",
            all_parents_count: 2,
            all_parents: ["aaa", "bbb"]
          },
          "ddd" => %{
            self: "ddd",
            parent: "ccc",
            all_parents_count: 3,
            all_parents: ["aaa", "bbb", "ccc"]
          },
          "eee" => %{self: "eee", parent: nil, all_parents_count: 0, all_parents: []},
          "fff" => %{self: "fff", parent: "eee", all_parents_count: 1, all_parents: ["eee"]}
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
          "COM" => %{self: "COM", parent: nil, all_parents_count: 0, all_parents: []},
          "BBB" => %{self: "BBB", parent: "COM", all_parents_count: 1, all_parents: ["COM"]},
          "CCC" => %{
            self: "CCC",
            parent: "BBB",
            all_parents_count: 2,
            all_parents: ["COM", "BBB"]
          },
          "DDD" => %{
            self: "DDD",
            parent: "CCC",
            all_parents_count: 3,
            all_parents: ["COM", "BBB", "CCC"]
          },
          "EEE" => %{
            self: "EEE",
            parent: "DDD",
            all_parents_count: 4,
            all_parents: ["COM", "BBB", "CCC", "DDD"]
          },
          "FFF" => %{
            self: "FFF",
            parent: "EEE",
            all_parents_count: 5,
            all_parents: ["COM", "BBB", "CCC", "DDD", "EEE"]
          },
          "GGG" => %{
            self: "GGG",
            parent: "BBB",
            all_parents_count: 2,
            all_parents: ["COM", "BBB"]
          },
          "HHH" => %{
            self: "HHH",
            parent: "GGG",
            all_parents_count: 3,
            all_parents: ["COM", "BBB", "GGG"]
          },
          "III" => %{
            self: "III",
            parent: "DDD",
            all_parents_count: 4,
            all_parents: ["COM", "BBB", "CCC", "DDD"]
          },
          "JJJ" => %{
            self: "JJJ",
            parent: "EEE",
            all_parents_count: 5,
            all_parents: ["COM", "BBB", "CCC", "DDD", "EEE"]
          },
          "KKK" => %{
            self: "KKK",
            parent: "JJJ",
            all_parents_count: 6,
            all_parents: ["COM", "BBB", "CCC", "DDD", "EEE", "JJJ"]
          },
          "LLL" => %{
            self: "LLL",
            parent: "KKK",
            all_parents_count: 7,
            all_parents: ["COM", "BBB", "CCC", "DDD", "EEE", "JJJ", "KKK"]
          }
        },
        count: 42
      }
    )
  end
end
