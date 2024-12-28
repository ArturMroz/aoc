# https://adventofcode.com/2024/day/24

inits, connections = File.read('inputs/24.txt').split("\n\n")

Gate = Struct.new(:type, :in1, :in2, :out, :val)

gates = {}

inits.split("\n").each do |line|
  wire, val = line.split(': ')
  gates[wire] = Gate.new('VAL', nil, nil, nil, val.to_i)
end

connections.split("\n").each do |line|
  in1, type, in2, _, out = line.split
  gates[out] = Gate.new(type, in1, in2, out, nil)
end

# PART I

def get_gate_val(gate_name, gates)
  gate = gates[gate_name]

  return gate.val unless gate.val.nil? # return cached value if available

  in1_val = get_gate_val(gate.in1, gates) if gate.in1
  in2_val = get_gate_val(gate.in2, gates) if gate.in2

  gate.val =
    case gate.type
    when 'AND' then in1_val & in2_val
    when 'XOR' then in1_val ^ in2_val
    when 'OR'  then in1_val | in2_val
    when 'VAL' then gate.val
    end
end

z_wires = gates.keys.filter { |k| k[0] == 'z' }.sort
z_bits  = z_wires.map { |gate| get_gate_val(gate, gates) }
z_val   = z_bits.reverse.join.to_i(2)

p z_val

# PART II

# generate a graph in Graphviz for manual debugging
gviz = "graph {"
i = 0

shapes = {
  "AND" => 'egg',
  "OR"  => 'invtriangle',
  "XOR" => 'invhouse',
}

connections.split("\n").sort.each do |line|
  in1, type, in2, _, out = line.split
  node_name = "#{type}#{i += 1}".downcase

  gviz += %(
    #{node_name} [shape=#{shapes[type]}, label="#{type}"]
    #{in1} -- #{node_name}
    #{in2} -- #{node_name}
    #{node_name} -- #{out}
  )
end

gviz += "\n"

# find suspicious z wires for easier debugging
x_wires = gates.keys.filter { |k| k[0] == 'x' }.sort
y_wires = gates.keys.filter { |k| k[0] == 'y' }.sort

x_bits = x_wires.map { |w| gates[w].val }
y_bits = y_wires.map { |w| gates[w].val }

x_val = x_bits.reverse.join.to_i(2)
y_val = y_bits.reverse.join.to_i(2)

expected_z_val  = x_val + y_val
expected_z_bits = expected_z_val.to_s(2).chars.reverse.map(&:to_i)

# wires are supicious if current z val is different than expected z val
sus_z_wires = expected_z_bits
  .zip(z_bits)
  .map.with_index { |(a, b), i| a != b ? i : nil }
  .compact

# paint supsicious nodes red for easier debugging
sus_z_wires.each do |idx|
  gviz += %(    z#{idx} [color="red"]\n)
end

gviz += "}"

# now we can inspect the graph by hand using Graphviz to find crossed wires
File.write('24_graph.txt', gviz)

# these were found by hand ¯\_(ツ)_/¯
wires_to_swap = ['z11', 'wpd', 'jqf', 'skh', 'wts', 'z37', 'z19', 'mdd'].sort.join(',')

puts wires_to_swap
