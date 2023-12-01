# https://adventofcode.com/2023/day/1

input = File.read('inputs/01.txt').split("\n")

# PART I

result = input
  .map { |row| row.scan(/\d/) }
  .map { |arr| arr.first + arr.last }
  .sum(&:to_i)

p result


# PART II

def parse_digit(str)
  case str
  when "one" then 1
  when "two" then 2
  when "three" then 3
  when "four" then 4
  when "five" then 5
  when "six" then 6
  when "seven" then 7
  when "eight" then 8
  when "nine" then 9
  else str.to_i
  end
end

result = input
  .map { |row| row.scan(/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/).flatten }
  .map { |arr| [arr.first, arr.last] }
  .sum { |a, b| 10 * parse_digit(a) + parse_digit(b) }

p result
