# https://adventofcode.com/2024/day/2

input = File.read('inputs/02.txt')
  .lines
  .map { |line| line.split.map(&:to_i) }

def safe_report?(report)
  report.each_cons(2).all? { |a, b| a - b > 0 && a - b <= 3 } || # strictly decreasing
    report.each_cons(2).all? { |a, b| b - a > 0 && b - a <= 3 }  # strictly increasing
end

# PART I

num_safe = input.count { |report| safe_report?(report) }

puts num_safe

# PART II

num_safe = input.count do |report|
  report.size.times.any? do |i|
    safe_report?(report[...i] + report[i + 1..])
  end
end

puts num_safe
