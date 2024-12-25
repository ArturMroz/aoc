# https://adventofcode.com/2024/day/23

input = File.read('inputs/23.txt').split("\n")

graph = Hash.new { |h, k| h[k] = Set.new }
input.each do |line|
  a, b = line.split('-')
  graph[a] << b
  graph[b] << a
end

# PART I

only_tees = graph.filter { |_, nodes| nodes.any? { |node| node[0] == 't'} }

tres_amigos = []

only_tees.keys.combination(2) do |k1, k2|
  next unless only_tees[k1].include?(k2)

  common_neighbours = only_tees[k1] & only_tees[k2]

  common_neighbours.each do |k3|
    if k1[0] == 't' || k2[0] == 't' || k3[0] == 't'
      tres_amigos << [k1, k2, k3].sort
    end
  end
end

p tres_amigos.uniq.size

# PART II

def bron_kerbosch(rset, pset, xset, graph)
  return rset if pset.empty? && xset.empty?

  max_clique = rset
  pivot      = (pset | xset).first

  (pset - graph[pivot]).each do |v|
    new_clique = bron_kerbosch(
      rset | [v],
      pset & graph[v],
      xset & graph[v],
      graph
    )

    max_clique = new_clique if new_clique.size > max_clique.size

    pset.delete(v)
    xset << v
  end

  max_clique
end

rset = Set.new
xset = Set.new
pset = Set.new graph.keys

max_clique = bron_kerbosch(rset, pset, xset, graph)

puts max_clique.sort.join(',')
