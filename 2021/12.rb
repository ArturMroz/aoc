# frozen_string_literal: true

# https://adventofcode.com/2021/day/12

input = File.read('inputs/12.txt').split("\n")

graph = Hash.new { |h, k| h[k] = [] }

input.each do |line|
  a, b = line.split('-')
  graph[a] << b
  graph[b] << a
end

# PART I

num_paths = 0
q         = [['start', []]]

until q.empty?
  cur, path = q.pop

  path << cur

  graph[cur].each do |neighbour|
    if neighbour == 'end'
      num_paths += 1
    elsif neighbour == neighbour.upcase || !path.include?(neighbour)
      # big caves or unvisited small caves
      q << [neighbour, path.dup]
    end
  end
end

p num_paths

# PART II

num_paths = 0
q         = [['start', [], false]]

until q.empty?
  cur, path, small_cave_revisited = q.pop

  path << cur

  graph[cur].each do |neighbour|
    if neighbour == 'end'
      num_paths += 1
    elsif neighbour == 'start'
      # cannot revisit the start node
      next
    elsif neighbour == neighbour.upcase || !path.include?(neighbour)
      # big caves or unvisited small caves
      q << [neighbour, path.dup, small_cave_revisited]
    elsif !small_cave_revisited
      # allow revisiting a small cave once
      q << [neighbour, path.dup, true]
    end
  end
end

p num_paths
