# https://adventofcode.com/2024/day/9

input = File.read('inputs/09.txt').chars.map(&:to_i)

blocks_og = input.map.with_index do |num, i|
  next if num == 0

  if i.even?
    [i / 2] * num
  else
    [-1] * num
  end
end.compact

def checksum(blocks)
  checksum = 0

  blocks.each_with_index do |num, i|
    next if num == -1

    checksum += num * i
  end

  checksum
end

# PART I

blocks = blocks_og.flatten

i = 0
j = blocks.size - 1

loop do
  i += 1 while blocks[i] != -1
  j -= 1 while blocks[j] == -1

  break if i > j

  blocks[i], blocks[j] = blocks[j], blocks[i]
end

p checksum(blocks)

# PART II

Node = Struct.new(:prev, :next, :id, :len, :processed) do
  def ==(other)
    id == other.id
  end
end

nodes = blocks_og.map do |b|
  Node.new(nil, nil, b[0], b.size, false)
end

nodes.each_cons(2) do |a, b|
  a.next = b
  b.prev = a
end

head = nodes.first

right = nodes.last

loop do
  # find the next unprocessed file (right node)
  right = right&.prev while right && (right.id <= 0 || right.processed)

  break unless right # exit if no files to process left

  # find the first empty space large enough to fit the file
  left = head
  while left && (left.id >= 0 || left.len < right.len)
    left = left.next

    left = nil if left == right # left and right iterators crossed over
  end

  if left.nil?
    # no space big enough for the file so mark it as processed
    right.processed = true
    next
  end

  # split empty space in 2 if the file isn't big enough to cover all space
  if left.len > right.len
    left.len = right.len

    new_node = Node.new(left, left.next, -1, left.len - right.len, false)
    left.next.prev = new_node if left.next
    left.next = new_node
  end

  # swap file with empty space
  left.id, right.id = right.id, left.id
  left.processed = true
end

def nodes_to_list(head)
  res = []

  cur = head
  while cur
    res += [cur.id] * cur.len
    cur = cur.next
  end

  res
end

blocks = nodes_to_list(head)

p checksum(blocks)
