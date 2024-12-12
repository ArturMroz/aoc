# https://adventofcode.com/2024/day/11

input = File.read('inputs/11.txt').split.map(&:to_i)

def find_num_stones(num_blinks, input)
  stones = input.tally
  stones.default = 0

  num_blinks.times do
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

  stones.values.sum
end

# PART I
p find_num_stones(25, input)

# PART II
p find_num_stones(75, input)
