# typed: true

# https://adventofcode.com/2023/day/19

input = File.read('inputs/19.txt').split("\n\n")

Rule = Struct.new(:key, :op, :val, :dst)

def parse_workflows(workflows_str)
  workflows_str.split("\n").each_with_object({}) do |workflow_str, workflows|
    name, rules_str = workflow_str.match(/(^\w+)\{(.*)\}/).captures
    rule_strs       = rules_str.split(',')

    rules = rule_strs[0...-1].map do |rule_str|
      key, op, val, dst = rule_str.match(/(^\w)([<>])(\d+):(\w+)/).captures
      Rule.new(key, op, val.to_i, dst)
    end

    rules << rule_strs.last

    workflows[name] = rules
  end
end

def parse_parts(parts_str)
  parts_str.split("\n").map do |part|
    part[1...-1]
      .split(',')
      .to_h { |prop| prop.split('=') }
      .transform_values(&:to_i)
  end
end

def solve_part1(workflows, parts)
  parts    = parts.map { |part| [part, 'in'] }
  accepted = []

  until parts.empty?
    part, workflow_name = parts.pop

    if workflow_name == 'A'
      accepted << part
      next
    elsif workflow_name == 'R'
      next
    end

    rules = workflows[workflow_name]

    rules.each do |rule|
      if rule.is_a?(String)
        parts << [part, rule]
      else
        part_val = part[rule.key]

        if (rule.op == '>' && part_val > rule.val) || (rule.op == '<' && part_val < rule.val)
          parts << [part, rule.dst]
          break
        end
      end
    end
  end

  accepted.sum { |part| part.values.sum }
end

def count_valid_combinations(workflows, part, workflow_name)
  if workflow_name == 'A'
    return part.values.map(&:size).reduce(:*)
  elsif workflow_name == 'R'
    return 0
  end

  total = 0

  workflows[workflow_name].each do |rule|
    if rule.is_a?(String)
      total += count_valid_combinations(workflows, part, rule)
    else
      adj_part = part.dup

      if rule.op == '<'
        adj_part[rule.key] = adj_part[rule.key].begin..rule.val - 1
        part[rule.key]     = rule.val..part[rule.key].end
      elsif rule.op == '>'
        adj_part[rule.key] = rule.val + 1..adj_part[rule.key].end
        part[rule.key]     = part[rule.key].begin..rule.val
      end

      total += count_valid_combinations(workflows, adj_part, rule.dst)
    end
  end

  total
end

def solve_part2(workflows)
  part = { 'x' => 1..4000, 'm' => 1..4000, 'a' => 1..4000, 's' => 1..4000 }

  count_valid_combinations(workflows, part, 'in')
end

workflows_str, parts_str = input

workflows = parse_workflows(workflows_str)
parts     = parse_parts(parts_str)

p solve_part1(workflows, parts)

p solve_part2(workflows)
