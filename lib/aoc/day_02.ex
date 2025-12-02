defmodule AoC.Day02 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.flat_map(fn {a, b} -> all_invalid(a - 1, b) end)
    |> Enum.sum()
  end

  def part2(input) do
    # i was too smart in p1. turns out we can just iterate over the range
    input
    |> parse_input()
    |> Enum.flat_map(fn {a, b} -> Enum.filter(a..b, &repeated_pattern?/1) end)
    |> Enum.sum()
  end

  def next_invalid(start) do
    digits = Integer.digits(start)
    len = length(digits)

    if rem(len, 2) != 0 do
      next_invalid(Integer.pow(10, len))
    else
      half = div(len, 2)
      {first_half, second_half} = Enum.split(digits, half)

      if second_half < first_half do
        Integer.undigits(first_half ++ first_half)
      else
        next_half = Integer.digits(Integer.undigits(first_half) + 1)
        Integer.undigits(next_half ++ next_half)
      end
    end
  end

  def all_invalid(start, finish) do
    next = next_invalid(start)
    if next > finish, do: [], else: [next | all_invalid(next, finish)]
  end

  defp repeated_pattern?(n) do
    digits = Integer.digits(n)
    len = length(digits)

    cond do
      len < 2 ->
        false

      true ->
        doubled = digits ++ digits
        Enum.any?(1..(len - 1), &(Enum.slice(doubled, &1, len) == digits))
    end
  end

  def parse_input(input) do
    input
    |> String.split([",", "\n"], trim: true)
    |> Enum.map(fn x ->
      [a, b] = String.split(x, "-")
      {String.to_integer(a), String.to_integer(b)}
    end)
  end
end
