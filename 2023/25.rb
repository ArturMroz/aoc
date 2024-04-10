# frozen_string_literal: true
# typed: true

# https://adventofcode.com/2023/day/25

input = File.read('inputs/25.txt').split("\n")

graph = Hash.new { |h, k| h[k] = [] }

input.each do |line|
  node, nodes = line.split(': ')

  nodes.split.each do |n|
    graph[node] << n
    graph[n] << node
  end
end

def bfs(graph, start, target)
  q    = [start]
  seen = Set.new([start])
  prev = {}

  until q.empty?
    nq = []

    q.each do |cur|
      graph[cur].each do |neighbour|
        next if seen.include?(neighbour)

        seen << neighbour

        prev[neighbour] = cur

        if neighbour == target
          path = []
          while target
            path << target
            target = prev[target]
          end

          return path
        end

        nq << neighbour
      end
    end

    q = nq
  end
end

freq = Hash.new(0)

# sample 1000 paths between two random nodes
1000.times do
  node1, node2 = graph.keys.sample(2)
  path = bfs(graph, node1, node2)

  path.each_cons(2) { |segment| freq[segment.sort] += 1 }
end

# 3 most common path segments are the ones we need to cut (these segments are 'bridges' between clusters)
most_common_connections = freq.sort_by { |_, v| -v }.first(3).map(&:first)

most_common_connections.each do |node1, node2|
  graph[node1].delete(node2)
  graph[node2].delete(node1)
end

def get_cluster_size(graph, start)
  q    = [start]
  seen = Set.new([start])

  until q.empty?
    graph[q.shift].each do |neighbour|
      next if seen.include?(neighbour)

      seen << neighbour
      q << neighbour
    end
  end

  seen.size
end

cluster_a_size = get_cluster_size(graph, graph.keys.first)
cluster_b_size = graph.size - cluster_a_size

p cluster_a_size * cluster_b_size
