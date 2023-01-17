# https://adventofcode.com/2022/day/7

path  = []
sizes = Hash.new(0)

File.read('inputs/07.txt').lines.each do |line|
  case line.split
  in ['$', 'cd', '/']  then path = []
  in ['$', 'cd', '..'] then path.pop
  in ['$', 'cd', dir]  then path << dir
  in ['$', 'ls']       then # nothing
  in ['dir', _]        then # nothing
  in [file_size, _]
    (0..path.size).each do |i|
      sizes[path.first(i)] += file_size.to_i
    end
  end
end

# PART I

p sizes.values.filter { |v| v <= 100000 }.sum

# PART II

total_space    = 70000000
required_space = 30000000
used_space     = sizes[[]]
needs_to_free  = required_space - (total_space - used_space)

p sizes.values.filter { |v| v >= needs_to_free }.min
