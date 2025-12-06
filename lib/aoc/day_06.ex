defmodule AoC.Day06 do
  def part1(input) do
    input |> parse_input_1() |> Enum.reduce(0, &do_op(&1, &2))
  end

  def part2(input) do
    input |> parse_input_2() |> Enum.reduce(0, &do_op(&1, &2))
  end

  def do_op({nums, "+"}, acc), do: Enum.sum(nums) + acc
  def do_op({nums, "*"}, acc), do: Enum.product(nums) + acc

  def parse_input_1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.zip()
    |> Enum.map(fn line ->
      {nums, [op]} = line |> Tuple.to_list() |> Enum.split(-1)
      nums = Enum.map(nums, &String.to_integer/1)
      {nums, op}
    end)
  end

  def parse_input_2(input) do
    lines = String.split(input, "\n", trim: true)
    {nums, [op]} = Enum.split(lines, -1)
    max_len = nums |> Enum.map(&String.length/1) |> Enum.max()

    zones =
      op
      |> String.pad_trailing(max_len)
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.scan(fn
        {c, i}, _ when c in [?*, ?+] -> {c, i}
        _, acc -> acc
      end)

    nums
    |> Enum.map(&(&1 |> String.pad_trailing(max_len) |> String.to_charlist()))
    |> Enum.zip_with(fn chars ->
      case chars |> Enum.filter(&(&1 != ?\s)) |> List.to_string() do
        "" -> nil
        s -> String.to_integer(s)
      end
    end)
    |> Enum.zip(zones)
    |> Enum.chunk_by(&elem(&1, 1))
    |> Enum.map(fn [{_, {op, _}} | _] = chunk ->
      {chunk |> Enum.map(&elem(&1, 0)) |> Enum.reject(&is_nil/1), <<op>>}
    end)
  end
end
