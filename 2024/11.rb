# https://adventofcode.com/2024/day/11

input = File.read('inputs/11.txt').split.map(&:to_i)

# PART I

stones = input

25.times do
  new_stones = []

  stones.each do |stone|
    if stone == 0
      new_stones << 1
    elsif (d = stone.digits.size) && d.even?
      s1, s2 = stone.divmod(10**(d / 2))
      new_stones << s1
      new_stones << s2
    else
      new_stones << stone * 2024
    end
  end

  stones = new_stones
end

p stones.size

# PART II

stones = input.tally
stones.default = 0

75.times do
  stones.dup.each do |stone, count|
    next if count == 0

    stones[stone] -= count

    if stone == 0
      stones[1] += count
    elsif (d = stone.digits.size) && d.even?
      s1, s2 = stone.divmod(10**(d / 2))
      stones[s1] += count
      stones[s2] += count
    else
      stones[stone * 2024] += count
    end
  end
end

p stones.values.sum
