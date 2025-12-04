defmodule AoC.Day04 do
  def part1(input) do
    {grid, _, _} = parse_input(input)

    Enum.count(grid, fn x -> grid |> AoC.Utils.Grid.neighbors(x, true) |> length() < 4 end)
  end

  def part2(input) do
    {grid, _, _} = parse_input(input)

    grid_count = MapSet.size(grid)
    new_grid_count = grid |> remove_rolls() |> MapSet.size()

    grid_count - new_grid_count
  end

  def remove_rolls(grid) do
    grid
    |> Enum.reduce(grid, fn x, acc ->
      if grid |> AoC.Utils.Grid.neighbors(x, true) |> length() < 4,
        do: MapSet.delete(acc, x),
        else: acc
    end)
    |> case do
      x when x != grid -> remove_rolls(x)
      _ -> grid
    end
  end

  def parse_input(input) do
    AoC.Utils.Grid.parse_grid_to_mapset(input, ["."])
  end
end
