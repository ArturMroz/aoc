# https://adventofcode.com/2021/day/19

input = File.read('inputs/19.txt').split("\n\n")

scanners = input.map do |scanner|
  beacons = scanner.lines.drop(1)

  beacons.map { |line| line.split(',').map(&:to_i) }
end

@scanners_pos = Hash.new { |h, k| h[k] = [] }
@coord_flips  = Hash.new { |h, k| h[k] = [] }
@coord_remaps = Hash.new { |h, k| h[k] = [] }

# Compute all pairwise distances for given beacons.
def compute_distances(beacons)
  beacons.combination(2).to_h do |b1, b2|
    diff = b1.zip(b2).map { |c1, c2| (c1 - c2).abs }

    [diff, [b1, b2]]
  end
end

# Find overlapping distances between two scanners.
def find_overlaps(distances1, distances2)
  overlaps = {}

  # precompute lookup table for fast checks
  distances2_lookup = distances2.keys.to_h { |key| [key.sort, key] }

  distances1.each_key do |key1|
    if (matched_key2 = distances2_lookup[key1.sort])
      overlaps[key1] = matched_key2
    end
  end

  overlaps
end

def determine_positions_and_flips(i1, distances1, i2, distances2, overlaps)
  ref_dist1, ref_dist2 = overlaps.first

  # determine remapping of coordinates based on first overlap
  @coord_remaps[i1][i2] = {
    0 => ref_dist2.index(ref_dist1[0]),
    1 => ref_dist2.index(ref_dist1[1]),
    2 => ref_dist2.index(ref_dist1[2])
  }

  # remap distances for scanner2 to match scanner1's coordinate system
  remapped_distances = overlaps.map do |key1, key2|
    coords_remapped = distances2[key2].map do |coord|
      coord.each_index.map { |j| coord[@coord_remaps[i1][i2][j]] }
    end
    [distances1[key1], coords_remapped]
  end

  # use the first beacon to establish a reference
  ref_beacon = distances1[ref_dist1][0]

  # filter pairs involving the reference beacon and find overlapping points
  filtered_pairs = remapped_distances
    .filter { |(b1_a, b1_b), _b2| b1_a == ref_beacon || b1_b == ref_beacon }
    .first(2)

  overlapping_points = filtered_pairs
    .flatten(2)
    .tally
    .filter { |_beacon, count| count == 2 }
    .keys

  # build the complete mapping of positions between beacons in two scanners
  mapping = {
    ref_beacon => overlapping_points.find { |p| p != ref_beacon }
  }

  filtered_pairs.each do |(b1_a, b1_b), (b2_a, b2_b)|
    mapping[b1_b] = (b2_a == mapping[b1_a] ? b2_b : b2_a) if mapping[b1_a]
    mapping[b1_a] = (b2_a == mapping[b1_b] ? b2_b : b2_a) if mapping[b1_b]
  end

  # try all flip combinations to find consistent translation
  [1, -1].repeated_permutation(3).each do |fx, fy, fz|
    translated_points = mapping.map do |k, v|
      [(k[0] * fx) + v[0], (k[1] * fy) + v[1], (k[2] * fz) + v[2]]
    end

    next unless translated_points[0] == translated_points[1]

    # calculate the position of scanner2 relative to scanner1
    translation = translated_points[0]
    other_scanner_position = [translation[0] * fx, translation[1] * fy, translation[2] * fz]

    @scanners_pos[i1][i2] = other_scanner_position
    @coord_flips[i1][i2] = [-fx, -fy, -fz]

    break
  end
end

# Remap given point to match other scanner's coordinate system.
def translate_point(point, scanner_from, scanner_to)
  v          = point.each_index.map { |i| point[@coord_remaps[scanner_to][scanner_from][i]] } # reorder cords
  origin     = @scanners_pos[scanner_to][scanner_from]
  fx, fy, fz = @coord_flips[scanner_to][scanner_from]

  [(v[0] * fx) + origin[0], (v[1] * fy) + origin[1], (v[2] * fz) + origin[2]]
end

scanners.each_with_index.to_a.combination(2) do |(beacons1, i1), (beacons2, i2)|
  distances1 = compute_distances(beacons1)
  distances2 = compute_distances(beacons2)

  overlaps = find_overlaps(distances1, distances2)

  next if overlaps.size < 12

  determine_positions_and_flips(i1, distances1, i2, distances2, overlaps)        # from scanner i1 to i2
  determine_positions_and_flips(i2, distances2, i1, distances1, overlaps.invert) # from scanner i2 to i1
end

graph = Hash.new { |h, k| h[k] = [] }

@scanners_pos.each do |(val, key)|
  key.each_with_index do |node, i|
    graph[i] << val if node
  end
end

require '../algos/bfs'

# finalized positions in the global coordinate system
final_scanners_positions = @scanners_pos.transform_values(&:compact)

(1...scanners.size).each do |scanner_idx|
  # the shortest path in the graph from the current scanner to scanner 0
  path = bfs(graph, scanner_idx, 0)

  path.reverse.each_cons(2) do |from, to|
    scanners[to] += scanners[from].map { |p| translate_point(p, from, to) }

    final_scanners_positions[to] += final_scanners_positions[from].map { |p| translate_point(p, from, to) }
  end
end

# PART I

p scanners[0].to_set.size

# PART II

manhattan_distances = final_scanners_positions[0].to_set.to_a.combination(2).map do |p1, p2|
  p1.zip(p2).sum { |c1, c2| (c1 - c2).abs }
end

p manhattan_distances.max
