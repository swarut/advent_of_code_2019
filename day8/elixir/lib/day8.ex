defmodule Day8 do
  def get_input do
    {:ok, result} = File.read("input.txt")
    result |> String.trim() |> String.graphemes()
  end

  def solve_part1(width, height) do
    input = get_input()

    layers = input |> Enum.chunk_every(width * height)

    counts =
      layers
      |> Enum.map(fn layer ->
        IO.puts("Layer : #{layer}")
        do_count(layer, %{})
      end)
      |> Enum.min_by(fn x -> x["0"] end)

    IO.puts("Result = #{inspect(counts)}")
    merged_layer = perform_merge(layers)
    lines = merged_layer |> Enum.chunk_every(width)

    lines
    |> Enum.each(fn x ->
      IO.puts(x |> Enum.join())
    end)
  end

  def do_count([h | t], acc) do
    acc = acc |> Map.update(h, 1, fn x -> x + 1 end)
    do_count(t, acc)
  end

  def do_count([], acc) do
    acc
  end

  def perform_merge([layer1, layer2 | rest]) do
    merged = merge_layers(layer1, layer2, [])
    perform_merge([merged | rest])
  end

  def perform_merge([last_layer]) do
    last_layer
  end

  def merge_layers([l1 | rest1], [l2 | rest2], acc) do
    acc = [merge(l1, l2) | acc]
    merge_layers(rest1, rest2, acc)
  end

  def merge_layers([], [], acc) do
    acc |> Enum.reverse()
  end

  def merge(l1, l2) do
    case l1 do
      "2" -> l2
      _ -> l1
    end
  end
end
