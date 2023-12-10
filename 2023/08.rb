# https://adventofcode.com/2023/day/8

input = File.read('inputs/08.txt').split("\n\n")

inst = input[0].chars.cycle.each

map = {}

input[1].lines.each do |line|
  node, left, right = line.scan(/\w+/)
  map[node] = [left, right]
end

# PART I

cur_node = 'AAA'
steps    = 0

until cur_node == 'ZZZ'
  cur_node = inst.next == 'L' ? map[cur_node][0] : map[cur_node][1]
  steps += 1
end

p steps

# PART II

starting_nodes = map.keys.filter { |k| k[2] == 'A' }
cur_nodes      = starting_nodes
steps_by_node  = {}
steps          = 0

until steps_by_node.size == starting_nodes.size
  next_inst = inst.next

  cur_nodes.each.with_index do |node, i|
    steps_by_node[i] = steps if node[2] == 'Z' && steps_by_node[i].nil?

    cur_nodes[i] = next_inst == 'L' ? map[node][0] : map[node][1]
  end

  steps += 1
end

result = steps_by_node.values.reduce(1, :lcm)

p result
