# frozen_string_literal: true
# typed: true

# https://adventofcode.com/2022/day/19

input = File.readlines('inputs/19.txt')

Blueprint = Struct.new(:id, :ore_robot_cost, :clay_robot_cost, :obsidian_robot_cost, :geode_robot_cost, :max_costs)
Bank      = Struct.new(:ore, :clay, :obsidian, :geode)
Robots    = Struct.new(:ore, :clay, :obsidian, :geode)

bluesprints = input.map do |line|
  id, ore_robot_cost, clay_robot_cost, obsidian_robot_cost_in_ore, obsidian_robot_cost_in_clay, geode_robot_cost_in_ore,
  geode_robot_cost_in_obsidian = line.scan(/\d+/).map(&:to_i)

  max_costs = {
    ore: [ore_robot_cost, clay_robot_cost, obsidian_robot_cost_in_ore, geode_robot_cost_in_ore].max,
    clay: obsidian_robot_cost_in_clay,
    obsidian: geode_robot_cost_in_obsidian
  }

  Blueprint.new(
    id,
    ore_robot_cost,
    clay_robot_cost,
    [obsidian_robot_cost_in_ore, obsidian_robot_cost_in_clay],
    [geode_robot_cost_in_ore, geode_robot_cost_in_obsidian],
    max_costs)
end

def mine(bank, robots, time)
  bank.ore      += robots.ore * time
  bank.clay     += robots.clay * time
  bank.obsidian += robots.obsidian * time
  bank.geode    += robots.geode * time
end

def dfs(b, bank, robots, time)
  if time == 0
    @max_geodes = [@max_geodes, bank.geode].max
    return
  end

  # bail if optimistic forecast of geodes is worse than current max
  return if bank.geode + (time * robots.geode) + ((time * (time - 1)) / 2) <= @max_geodes

  if time == 1
    mine(bank, robots, 1)
    dfs(b, bank, robots, 0)
    return # no point in building robots in the last minute
  end

  if b.geode_robot_cost[1] <= bank.obsidian && b.geode_robot_cost[0] <= bank.ore
    bank_next   = bank.dup
    robots_next = robots.dup

    mine(bank_next, robots_next, 1)

    robots_next.geode += 1
    bank_next.ore      -= b.geode_robot_cost[0]
    bank_next.obsidian -= b.geode_robot_cost[1]

    dfs(b, bank_next, robots_next, time - 1)

    return # building a geode bot is always the best move in practice, don't consider other options
  end

  if robots.obsidian < b.max_costs[:obsidian] && robots.clay > 0
    rounds_needed_for_ore      = ((b.obsidian_robot_cost[0] - bank.ore) / robots.ore.to_f).ceil + 1
    rounds_needed_for_obsidian = ((b.obsidian_robot_cost[1] - bank.clay) / robots.clay.to_f).ceil + 1
    rounds_needed              = [1, rounds_needed_for_ore, rounds_needed_for_obsidian].max

    bank_next   = bank.dup
    robots_next = robots.dup

    mine(bank_next, robots_next, rounds_needed)

    robots_next.obsidian += 1
    bank_next.ore  -= b.obsidian_robot_cost[0]
    bank_next.clay -= b.obsidian_robot_cost[1]

    dfs(b, bank_next, robots_next, time - rounds_needed) if time > rounds_needed
  end

  if robots.clay < b.max_costs[:clay]
    bank_next   = bank.dup
    robots_next = robots.dup

    rounds_needed = [1, ((b.clay_robot_cost - bank.ore) / robots.ore.to_f).ceil + 1].max

    mine(bank_next, robots_next, rounds_needed)

    robots_next.clay += 1
    bank_next.ore -= b.clay_robot_cost

    dfs(b, bank_next, robots_next, time - rounds_needed) if time > rounds_needed
  end

  if robots.ore < b.max_costs[:ore]
    bank_next   = bank.dup
    robots_next = robots.dup

    rounds_needed = [1, ((b.ore_robot_cost - bank.ore) / robots.ore.to_f).ceil + 1].max

    mine(bank_next, robots_next, rounds_needed)

    robots_next.ore += 1
    bank_next.ore -= b.ore_robot_cost

    dfs(b, bank_next, robots_next, time - rounds_needed) if time > rounds_needed
  end
end

# PART I

score = bluesprints.sum do |b|
  @max_geodes = 0
  dfs(b, Bank.new(0, 0, 0, 0), Robots.new(1, 0, 0, 0), 24)

  b.id * @max_geodes
end

p score

# PART II

solutions = bluesprints.first(3).map do |b|
  @max_geodes = 0
  dfs(b, Bank.new(0, 0, 0, 0), Robots.new(1, 0, 0, 0), 32)

  @max_geodes
end

p solutions.reduce(:*)
