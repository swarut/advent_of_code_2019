defmodule Day3 do
  def get_input do
    {:ok, result} = File.read("input.txt")

    String.split(result, [",", "\n"], trim: true)
    |> Enum.map(fn x -> String.to_integer(x) end)
  end
  def hello do
    :world
  end
end
