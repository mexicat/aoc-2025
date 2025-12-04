defmodule AoC.Utils.Grid do
  @type mapgrid() :: %{{non_neg_integer(), non_neg_integer()} => atom()}
  @type mapsetgrid() :: MapSet.t({non_neg_integer(), non_neg_integer()})

  @dirs [{0, -1}, {0, 1}, {-1, 0}, {1, 0}]
  @all_dirs [{0, -1}, {0, 1}, {-1, 0}, {1, 0}, {1, 1}, {1, -1}, {-1, 1}, {-1, -1}]

  @spec parse_grid_to_map(String.t(), [String.t(), ...] | []) ::
          {mapgrid(), non_neg_integer(), non_neg_integer()}
  def parse_grid_to_map(input, exclude \\ [], cast \\ &String.to_atom/1) do
    {grid, max_x, max_y} =
      input
      |> String.trim()
      |> String.codepoints()
      |> Enum.reduce({%{}, 0, 0}, fn c, {acc, x, y} ->
        cond do
          c == "\n" -> {acc, 0, y + 1}
          c not in exclude -> {Map.put(acc, {x, y}, cast.(c)), x + 1, y}
          true -> {acc, x + 1, y}
        end
      end)

    {grid, max_x - 1, max_y}
  end

  @spec parse_grid_to_mapset(String.t()) :: {mapsetgrid(), non_neg_integer(), non_neg_integer()}
  def parse_grid_to_mapset(input, exclude \\ [], marks \\ []) do
    {grid, max_x, max_y, m} =
      input
      |> String.trim()
      |> String.codepoints()
      |> Enum.reduce({MapSet.new(), 0, 0, []}, fn c, {acc, x, y, m} ->
        cond do
          c == "\n" -> {acc, 0, y + 1, m}
          c in marks -> {MapSet.put(acc, {x, y}), x + 1, y, [{String.to_atom(c), {x, y}} | m]}
          c not in exclude -> {MapSet.put(acc, {x, y}), x + 1, y, m}
          true -> {acc, x + 1, y, m}
        end
      end)

    if length(marks) > 0 do
      {grid, max_x - 1, max_y, m}
    else
      {grid, max_x - 1, max_y}
    end
  end

  def neighbors(grid, point, all_dirs \\ false)

  def neighbors(grid, {x, y}, all_dirs) when is_non_struct_map(grid) do
    dirs = if all_dirs, do: @all_dirs, else: @dirs

    dirs
    |> Enum.map(fn {dx, dy} ->
      nb = {x + dx, y + dy}
      {nb, Map.get(grid, nb)}
    end)
    |> Enum.reject(fn {_, v} -> is_nil(v) end)
  end

  def neighbors(grid, {x, y}, all_dirs) do
    dirs = if all_dirs, do: @all_dirs, else: @dirs

    dirs
    |> Enum.map(fn {dx, dy} ->
      nb = {x + dx, y + dy}
      {nb, MapSet.member?(grid, nb)}
    end)
    |> Enum.reject(fn {_, v} -> not v end)
    |> Enum.map(fn {nb, _} -> nb end)
  end

  @spec visualize(mapgrid()) :: mapgrid()
  def visualize(grid, max_x \\ nil, max_y \\ nil)

  def visualize(grid, max_x, max_y) when is_non_struct_map(grid) do
    max_x = max_x || grid |> Map.keys() |> Enum.map(&elem(&1, 0)) |> Enum.max()
    max_y = max_y || grid |> Map.keys() |> Enum.map(&elem(&1, 1)) |> Enum.max()

    for y <- 0..max_y do
      for x <- 0..max_x do
        Map.get(grid, {x, y}, "#")
      end
      |> Enum.join()
    end
    |> Enum.join("\n")
    |> IO.puts()

    grid
  end

  def visualize(grid, max_x, max_y) do
    max_x = max_x || grid |> Enum.map(&elem(&1, 0)) |> Enum.max()
    max_y = max_y || grid |> Enum.map(&elem(&1, 1)) |> Enum.max()

    for y <- 0..max_y do
      for x <- 0..max_x do
        case MapSet.member?(grid, {x, y}) do
          true -> "#"
          false -> "."
        end
      end
      |> Enum.join()
    end
    |> Enum.join("\n")
    |> IO.puts()

    grid
  end
end
