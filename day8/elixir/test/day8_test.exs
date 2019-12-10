defmodule Day8Test do
  use ExUnit.Case

  test "merge layers" do
    layer1 = ["2", "2", "1", "0", "2", "2"]
    layer2 = ["1", "0", "0", "1", "1", "2"]
    assert(Day8.merge_layers(layer1, layer2, []) == ["1", "0", "1", "0", "1", "2"])
  end

  test "perform merge" do
    layer1 = ["2", "2", "1", "0", "2", "2"]
    layer2 = ["1", "0", "0", "1", "1", "2"]
    layer3 = ["2", "0", "2", "1", "1", "1"]
    assert(Day8.perform_merge([layer1, layer2, layer3]) == ["1", "0", "1", "0", "1", "1"])
  end

  test "perform merge 2" do
    layer1 = ["0", "2", "2", "2"]
    layer2 = ["1", "1", "2", "2"]
    layer3 = ["2", "2", "1", "2"]
    layer4 = ["0", "0", "0", "0"]
    assert(Day8.perform_merge([layer1, layer2, layer3, layer4]) == ["0", "1", "1", "0"])
  end
end
