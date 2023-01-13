# https://adventofcode.com/2022/day/4

result = File.read('inputs/04.txt')
  .lines
  .count do |line|
    elf1, elf2 = line.split(',')
    l1, r1 = elf1.split('-').map(&:to_i)
    l2, r2 = elf2.split('-').map(&:to_i)

    # part I
    # (l1 >= l2 && r1 <= r2) || (l1 <= l2 && r1 >= r2)

    # part II
    l1 <= r2 && l2 <= r1
  end

p result