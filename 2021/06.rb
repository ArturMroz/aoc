# https://adventofcode.com/2021/day/6

input = File.read('inputs/06.txt').scan(/\d+/).map(&:to_i)

school = Array.new(9, 0)

input.each { |fish| school[fish] += 1 }

256.times do |day|
  num_new_fish = school.shift
  school[6] += num_new_fish
  school << num_new_fish

  p school.sum if day == 17 # part I
end

p school.sum # part II
