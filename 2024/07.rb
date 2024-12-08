# https://adventofcode.com/2024/day/7

input = File.read('inputs/07.txt').split("\n")

add    = ->(a, b) { a + b }
mul    = ->(a, b) { a * b }
concat = ->(a, b) { (a * (10**b.digits.size)) + b }

def produces_test_value?(target, ops, result, nums)
  return result == target if nums.empty?

  return false if result > target

  ops.each do |op|
    result_so_far = op.call(result, nums.first)

    return true if produces_test_value?(target, ops, result_so_far, nums.drop(1))
  end

  false
end

p1_answer = 0
p2_answer = 0

input.each do |line|
  test_value, first_num, *nums = line.scan(/\d+/).map(&:to_i)

  p1_answer += test_value if produces_test_value?(test_value, [add, mul], first_num, nums)
  p2_answer += test_value if produces_test_value?(test_value, [add, mul, concat], first_num, nums)
end

p p1_answer
p p2_answer
