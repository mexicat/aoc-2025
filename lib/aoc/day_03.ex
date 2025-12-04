defmodule AoC.Day03 do
  def part1(input) do
    input |> parse_input() |> Enum.map(&find_joltage(&1, 2, [])) |> Enum.sum()
  end

  def part2(input) do
    input |> parse_input() |> Enum.map(&find_joltage(&1, 12, [])) |> Enum.sum()
  end

  def find_joltage(_, 0, acc), do: acc |> Enum.reverse() |> Integer.undigits()

  def find_joltage(line, amt, acc) do
    {num, i} =
      line
      |> Enum.with_index()
      |> Enum.drop(-(amt - 1))
      |> Enum.max(fn {x, a}, {y, b} -> x >= y and a < b end)

    rest = Enum.drop(line, i + 1)

    find_joltage(rest, amt - 1, [num | acc])
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> line |> String.to_integer() |> Integer.digits() end)
  end
end
