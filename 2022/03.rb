# https://adventofcode.com/2022/day/3

input = File.read('inputs/03.txt').split("\n")

def get_priority ch
  case ch
  when 'a'..'z' then ch.ord - 96 # 1  to 26
  when 'A'..'Z' then ch.ord - 38 # 27 to 52
  end
end

# PART I

result = input
  .sum do |row| 
    left, right = row.chars.each_slice(row.size/2).to_a
    common = (left & right)[0] # common element is the intersection of two collections
    get_priority common
  end

p result

# PART II

result = input
  .map(&:chars)
  .each_slice(3)
  .sum do |elf1, elf2, elf3| 
    common = (elf1 & elf2 & elf3)[0] 
    get_priority common
  end

p result
