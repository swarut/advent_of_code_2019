defmodule Day10 do
  def get_input do
    {:ok, result} = File.read("input.txt")

    String.split(result, [",", "\n"], trim: true)
    |> coordinates_from_lines
  end

  def solve_part1() do
    get_input()
  end

  def coordinates_from_lines(lines) do
    %{coordinates: coordinates} =
      lines
      |> Enum.reduce(
        %{row: 0, coordinates: []},
        fn line, %{row: row, coordinates: coordinates} = acc ->
          new_coordinates = coordinates_from_line(line, row)
          acc |> Map.put(:row, row + 1) |> Map.put(:coordinates, [new_coordinates | coordinates])
        end
      )

    coordinates |> Enum.reverse() |> List.flatten()
  end

  def coordinates_from_line(line, row) do
    extract_coordinates(line |> String.graphemes(), row, 0, [])
  end

  def extract_coordinates(["." | rest], row, col, acc) do
    extract_coordinates(rest, row, col + 1, acc)
  end

  def extract_coordinates(["#" | rest], row, col, acc) do
    extract_coordinates(rest, row, col + 1, [{row, col} | acc])
  end

  def extract_coordinates([], _row, _col, acc) do
    acc |> Enum.reverse()
  end
end
