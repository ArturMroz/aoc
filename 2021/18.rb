# https://adventofcode.com/2021/day/18

input = File.read('inputs/18.txt').split("\n")

Node = Struct.new(:left, :right, :val)

def parse_tree(num)
  return Node.new(nil, nil, num) if num.is_a?(Integer)

  left, right = num

  Node.new(parse_tree(left), parse_tree(right), nil)
end

def get_leaves_in_order(node)
  return [node] if node.val

  get_leaves_in_order(node.left) + get_leaves_in_order(node.right)
end

def explode(root, node)
  node.val = 0

  leaves   = get_leaves_in_order(root)
  node_idx = leaves.find_index { |n| n.equal?(node) }

  leaves[node_idx - 1].val += node.left.val  if node_idx - 1 >= 0
  leaves[node_idx + 1].val += node.right.val if node_idx + 1 < leaves.size

  node.left  = nil
  node.right = nil
end

def split(node)
  left_val  = (node.val / 2.0).floor
  right_val = (node.val / 2.0).ceil

  node.val   = nil
  node.left  = Node.new(nil, nil, left_val)
  node.right = Node.new(nil, nil, right_val)
end

def add(a, b)
  root = Node.new(a, b, nil)

  reduce(root)

  root
end

def reduce(root)
  loop do
    case find_next_op(root)
    in [:explode, node]
      explode(root, node)
    in [:split, node]
      split(node)
    else
      break
    end
  end

  root
end

def find_next_op(node)
  find_next_explode(node) || find_next_split(node)
end

def find_next_explode(node, lvl = 0)
  return nil              if node.val
  return [:explode, node] if lvl == 4

  find_next_explode(node.left, lvl + 1) || find_next_explode(node.right, lvl + 1)
end

def find_next_split(node)
  return [:split, node] if node.val&.> 9
  return nil            if node.val

  find_next_split(node.left) || find_next_split(node.right)
end

def magnitude(node)
  return node.val if node.val

  (3 * magnitude(node.left)) + (2 * magnitude(node.right))
end

# PART I

nums = input.map { |line| parse_tree(eval(line)) }

result = nums.reduce { |acc, cur| add(acc, cur) }

p magnitude(result)

# PART II

nums = input.map { |line| parse_tree(eval(line)) }

magnitudes = []
nums.permutation(2).each do |num1, num2|
  a = Marshal.load(Marshal.dump(num1))
  b = Marshal.load(Marshal.dump(num2))
  magnitudes << magnitude(add(a, b))

  a = Marshal.load(Marshal.dump(num1))
  b = Marshal.load(Marshal.dump(num2))
  magnitudes << magnitude(add(b, a))
end

p magnitudes.max
