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

# PART I

blocks = blocks_og.flatten

i = 0
j = blocks.size - 1

loop do
  i += 1 while blocks[i] != -1
  j -= 1 while blocks[j] == -1

  break if i >= j

  blocks[i], blocks[j] = blocks[j], blocks[i]
end

checksum = 0
blocks.each_with_index do |num, i|
  break if num == -1

  checksum += num * i
end

p checksum

# PART II

Node = Struct.new(:prev, :next, :id, :len, :processed)

nodes = blocks_og.map do |b|
  Node.new(nil, nil, b[0], b.size, false)
end

nodes.each_cons(2) do |a, b|
  a.next = b
  b.prev = a
end

head  = nodes.first
right = nodes.last

loop do
  # find the next unprocessed file (right node)
  right = right.prev while right && (right.id <= 0 || right.processed)

  break unless right # exit if no files to process left

  left = head
  # find the first empty space large enough to fit the file
  while left && (left.id >= 0 || left.len < right.len)
    left = left.next

    # using `equal?` instead of `==` so the nodes aren't compared recursively
    left = nil if left.equal?(right) # left and right iterators crossed over
  end

  if left.nil?
    # no space big enough for the file so mark it as processed
    right.processed = true
    next
  end

  # split empty space in 2 if the file isn't big enough to cover all space
  if left.len > right.len
    new_node = Node.new(left, left.next, -1, left.len - right.len, false)
    left.next.prev = new_node if left.next
    left.next = new_node
    left.len = right.len
  end

  # swap file with empty space
  left.id, right.id = right.id, left.id
  left.processed = true
end

checksum = 0
i        = 0
cur      = head

while cur
  checksum += (i...(i + cur.len)).sum { |j| j * cur.id } if cur.id != -1

  i += cur.len
  cur = cur.next
end

puts checksum
