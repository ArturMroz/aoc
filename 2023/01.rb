# https://adventofcode.com/2023/day/1

input = File.read('inputs/01.txt').lines

# PART I

result = input
    .map { |line| line.scan(/\d/) }
    .map { |arr| arr.first + arr.last }
    .sum(&:to_i)

p result

# PART II

NUMS = %w[one two three four five six seven eight nine].freeze

def parse_digit(str)
    idx = NUMS.index str
    idx ? idx + 1 : str.to_i
end

result = input
    .map { |line| line.scan(/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/).flatten }
    .map { |arr| [arr.first, arr.last] }
    .sum { |a, b| (10 * parse_digit(a)) + parse_digit(b) }

p result
