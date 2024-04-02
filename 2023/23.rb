# frozen_string_literal: true
# typed: true

# https://adventofcode.com/2023/day/23

input = File.read('inputs/23.demo.txt')

Grid   = input.split("\n").map(&:chars)
Width  = Grid[0].size
Height = Grid.size

start  = [1, 0]
target = [Width - 2, Height - 1]

require 'set'

def dfs(graph, node, target, seen, current_path_length)
  return current_path_length if node == target

  seen << node

  longest_path_length = 0

  graph[node].each do |dist, neighbour|
    next if seen.include?(neighbour)

    new_path_length = current_path_length + dist

    longest_path_length = [longest_path_length, dfs(graph, neighbour, target, seen, new_path_length)].max
  end

  seen.delete(node)

  longest_path_length
end

# PART I

graph_p1 = {}

Grid.each_with_index do |row, y|
  row.each_with_index do |col, x|
    next if col == '#'

    result = []

    result << [x + 1, y] if ['.', '>'].include?(Grid.dig(y, x + 1))
    result << [x - 1, y] if Grid.dig(y, x - 1) == '.'
    result << [x, y + 1] if ['.', 'v'].include?(Grid.dig(y + 1, x))
    result << [x, y - 1] if Grid.dig(y - 1, x) == '.'

    graph_p1[[x, y]] = result.map { |r| [1, r] }
  end
end

p1_answer = dfs(graph_p1, start, target, Set.new, 0)

p p1_answer

# PART II

def valid_position?(x, y)
  ['.', '>', 'v'].include?(Grid.dig(y, x))
end

def get_neighbours_p2((x, y))
  [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]].filter { |nx, ny| valid_position?(nx, ny) }
end

intersections = [start, target]

Grid.each_with_index do |row, y|
  row.each_with_index do |col, x|
    next if col == '#'

    intersections << [x, y] if get_neighbours_p2([x, y]).size > 2
  end
end

graph_p2 = Hash.new { |h, k| h[k] = [] }

intersections.each do |intersection|
  q    = [intersection]
  seen = [intersection].to_set
  dist = 0

  until q.empty?
    nq = []
    dist += 1

    q.each do |node|
      get_neighbours_p2(node).each do |neighbour|
        next if seen.include?(neighbour)

        seen << neighbour

        if intersections.include?(neighbour)
          graph_p2[intersection] << [dist, neighbour]
        else
          nq << neighbour
        end
      end
    end

    q = nq
  end
end

p2_answer = dfs(graph_p2, start, target, Set.new, 0)

p p2_answer
