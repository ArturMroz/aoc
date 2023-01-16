# https://adventofcode.com/2022/day/6

def solve marker_len
  File.read('inputs/06.txt')
    .chars
    .each_cons(marker_len).with_index do |seq, i|
      return i+marker_len if seq.uniq.size == marker_len
    end
end

# part I
p solve 4

# part II
p solve 14