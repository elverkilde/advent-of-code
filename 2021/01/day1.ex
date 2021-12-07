defmodule Day1 do
  def input do
	File.stream!("input.txt")
	|> Enum.map(&(&1 |> Integer.parse |> elem(0)))
  end
  
  def part1 x do
	x
	|> Enum.map_reduce(0, &({&1 > &2, &1}))
	|> elem(0)
	|> Enum.count(&(&1))
  end

  def part2 x do
	x
	|> Enum.chunk_every(3, 1)
	|> Enum.map(&Enum.sum/1)
  end
end
