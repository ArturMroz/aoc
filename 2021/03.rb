# https://adventofcode.com/2021/day/3

input = File.read('inputs/03.txt').split("\n")

# PART I

ones_count = [0] * input[0].size

ones_count.each_index do |i|
  ones_count[i] = input.count { |line| line[i] == '1' }
end

gamma   = ones_count.map { |cnt| cnt > input.size / 2 ? '1' : '0' }.join
epsilon = gamma.tr('10', '01') # flip bits of gamma to get epsilon

p gamma.to_i(2) * epsilon.to_i(2)

# PART II

def rating(nums, prefer_most_common)
  i = 0

  until nums.size == 1
    ones_count = nums.count { |num| num[i] == '1' }
    winner     = if prefer_most_common
                   ones_count >= nums.size / 2 ? '1' : '0'
                 else
                   ones_count < nums.size / 2 ? '1' : '0'
                 end

    nums = nums.filter { |num| num[i] == winner }
    i += 1
  end

  nums.first.to_i(2)
end

oxygen_generator_rating = rating(input, true)
co2_scrubber_rating     = rating(input, false)

p oxygen_generator_rating * co2_scrubber_rating
