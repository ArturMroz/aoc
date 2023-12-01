# https://adventofcode.com/2023/day/1

input = File.read('inputs/01.txt').split("\n")

# PART I

result = input
  .map { |row| row.scan(/\d/) }
  .map { |arr| arr.first + arr.last }
  .map(&:to_i)
  .sum

p result


# PART II

def to_digit(str)
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
  .map { |arr| arr.map { |str| to_digit(str) } }
  .map { |digits| digits[0] * 10 + digits[1] }
  .sum

p result