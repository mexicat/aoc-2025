defmodule AoC.Day05 do
  def part1(input) do
    {ranges, available} = parse_input(input)

    Enum.count(available, fn x -> Enum.any?(ranges, &(x in &1)) end)
  end

  def part2(input) do
    {ranges, _} = parse_input(input)

    ranges
    |> simplify()
    |> Enum.reduce(0, &(Range.size(&1) + &2))
  end

  def simplify(ranges) do
    ranges
    |> Enum.sort_by(& &1.first)
    |> Enum.reduce([], fn
      range, [] -> [range]
      a..b//_, [x..y//_ | rest] when a <= y -> [x..max(b, y) | rest]
      range, acc -> [range | acc]
    end)
  end

  def parse_input(input) do
    [ranges, available] = String.split(input, "\n\n", trim: true)

    ranges =
      ranges
      |> String.split("\n", trim: true)
      |> Enum.map(fn range ->
        [start, end_] = String.split(range, "-")
        String.to_integer(start)..String.to_integer(end_)
      end)

    available =
      available
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)

    {ranges, available}
  end
end
