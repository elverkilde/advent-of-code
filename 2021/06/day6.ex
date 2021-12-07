defmodule Day6 do
  def input do
	File.read!("input.txt")
	|> then &String.trim/1
  end

  def parse line do
	String.split(line, ",")
	|> Enum.map(&String.to_integer/1)
  end

  def example do
	"3,4,3,1,2"
  end

  def fill fish do
	Map.merge(
	  Map.new(0..8, fn x -> {x,0} end),
	  fish
	)
  end
  
  def step(fish, 0), do: fish
  def step(fish, t) do
	step(%{8 => fish[0],
		   7 => fish[8],
		   6 => fish[7] + fish[0],
		   5 => fish[6],
		   4 => fish[5],
		   3 => fish[4],
		   2 => fish[3],
		   1 => fish[2],
		   0 => fish[1]},
	  t-1)
  end

  def calculate(fish, steps) do
	fish
	|> parse
	|> Enum.frequencies
	|> fill
	|> step(steps)
	|> Map.values
	|> Enum.sum
  end	
  
  def part1 x do
	x
	|> calculate(80)
  end

  def part2 x do
	x
	|> calculate(256)
  end
end
