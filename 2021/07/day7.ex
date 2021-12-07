defmodule Day7 do
  def input do
	File.read!("input.txt")
	|> then &String.trim/1
  end

  def parse line do
	String.split(line, ",")
	|> Enum.map(&String.to_integer/1)
  end

  def example do
	"16,1,2,0,4,2,7,1,2,14"
  end

  def calculate(x, cost) do
	x
	|> Enum.map(fn alignment ->
	  Enum.map(x, fn p -> cost.(abs(p - alignment)) end)
	  |> then(fn x -> {Enum.sum(x), alignment} end)
	end)
	|> then(&Enum.min/1)
  end

  def part1 x do
	x
	|> calculate (fn x -> x end)
  end

  def part2 x do
	x
	|> calculate (fn dist -> trunc((dist * dist + dist) / 2) end)
  end
end
