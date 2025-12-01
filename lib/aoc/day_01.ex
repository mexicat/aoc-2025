defmodule AoC.Day01 do
  @size 100
  @start 50

  def part1(input) do
    input
    |> parse_input()
    |> Enum.reduce({@start, 0}, fn dist, {dial, acc} ->
      case rotate(dial, dist) do
        0 -> {0, acc + 1}
        x -> {x, acc}
      end
    end)
    |> elem(1)
  end

  def part2(input) do
    input
    |> parse_input()
    |> Enum.reduce({@start, 0}, fn dist, {dial, acc} ->
      {rotate(dial, dist), acc + zeros_crossed(dial, dist)}
    end)
    |> elem(1)
  end

  defp rotate(dial, dist) do
    case rem(dial + dist, @size) do
      x when x < 0 -> @size + x
      x -> x
    end
  end

  def zeros_crossed(dial, dist) when dist >= 0 do
    Integer.floor_div(dial + dist, @size) - Integer.floor_div(dial, @size)
  end

  def zeros_crossed(dial, dist) when dist < 0 do
    Integer.floor_div(dial - 1, @size) - Integer.floor_div(dial + dist - 1, @size)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn
      "L" <> x -> -String.to_integer(x)
      "R" <> x -> String.to_integer(x)
    end)
  end
end
