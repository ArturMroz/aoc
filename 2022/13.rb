# https://adventofcode.com/2022/day/13

input = File.read('inputs/13.txt') 

def compare(a, b)
  case [a, b]
  in [Integer, Integer] then a <=> b
  in [Integer, _]       then compare([a], b)
  in [_, Integer]       then compare(a, [b])
  in [Array, Array]
    a.each_index do |i|
      return 1 if i >= b.size
      result = compare(a[i], b[i])
      return result if result != 0
    end
    a.size < b.size ? -1 : 0
  end
end

# PART I

result = input
  .split("\n\n")
  .map.with_index do |packet, i|
    a, b = packet.split("\n").map { |x| eval(x) }
    compare(a, b) < 0 ? i+1 : 0
  end
  .sum

p result

# PART II

divider_packets = [[[2]], [[6]]]

sorted_packets = input
  .split("\n")
  .reject(&:empty?)
  .map { |x| eval(x) }
  .+(divider_packets)
  .sort { |a, b| compare(a, b) }

result = divider_packets
  .map { |packet| sorted_packets.index(packet) + 1 }
  .reduce(&:*)

p result
