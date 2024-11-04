# https://adventofcode.com/2022/day/16

nodes  = {}
$rates = {}
$dists = Hash.new { |h, k| h[k] = Hash.new(1000) }

File.read('inputs/16.txt').split("\n").each do |line|
  v, *neighbours = line.scan(/[A-Z]{2}/)
  rate = line[/\d+/].to_i

  nodes[v]  = neighbours
  $rates[v] = rate if rate != 0 # ignore jammed valves to reduce search space

  neighbours.each { |u| $dists[u][v] = 1 }
end

$indices = $rates.keys.each_with_index.to_h { |x, i| [x, 1 << i] }

# Floyd-Warshall to calculate distances between every node
nodes.keys.product(nodes.keys, nodes.keys) do |k, i, j|
  $dists[i][j] = [$dists[i][j], $dists[i][k] + $dists[k][j]].min
end

def dfs(v, time, state, flow, answer)
  answer[state] = [answer[state], flow].max
  $rates.keys.each do |u|
    new_time = time - $dists[v][u] - 1
    next if $indices[u] & state != 0 || new_time <= 0

    dfs(u, new_time, state | $indices[u], flow + new_time*$rates[u], answer)
  end
  answer
end

# part I
p dfs('AA', 30, 0, 0, Hash.new(0)).values.max

# part II
seen = dfs('AA', 26, 0, 0, Hash.new(0))
total = seen.keys.combination(2).map do |k1, k2|
  seen[k1] + seen[k2] if k1 & k2 == 0
end.compact.max

p total
