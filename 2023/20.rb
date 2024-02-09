# typed: true

# https://adventofcode.com/2023/day/20

input = File.read('inputs/20.txt').split("\n")

ElfModule = Struct.new(:name, :type, :state, :memory, :pulse, :targets)

def parse_modules(input)
  modules = {}

  input.each do |line|
    name, targets = line.split(' -> ')
    targets       = targets.split(', ')

    type   = :normal
    state  = :off
    memory = {}
    pulse  = :low

    if name[0] == '%'
      name = name[1..]
      type = :flip_flop
    elsif name[0] == '&'
      name = name[1..]
      type = :conjuction
    end

    modules[name] = ElfModule.new(name, type, state, memory, pulse, targets)
  end

  modules.values.select { |m| m.type == :conjuction }.each do |conj_module|
    conj_module.memory = modules
      .select { |_, v| v.targets.include?(conj_module.name) }
      .keys
      .to_h { |input_module| [input_module, :low] }
  end

  modules
end

def press_button(modules, counts, i)
  q = [modules['broadcaster']]

  counts[:low] += 1

  until q.empty?
    cur_module = q.shift

    pulse = cur_module.pulse

    cur_module.targets.each do |target_name|
      target = modules[target_name]

      counts[pulse] += 1

      next if target.nil?

      FINAL_MODULES.each do |fm_name|
        counts[fm_name] = i if target_name == fm_name && pulse == :low
      end

      if target.type == :flip_flop && pulse == :low
        if target.state == :on
          target.state = :off
          target.pulse = :low
        else
          target.state = :on
          target.pulse = :high
        end
        q << target

      elsif target.type == :conjuction
        target.memory[cur_module.name] = pulse
        target.pulse = target.memory.values.all?(:high) ? :low : :high
        q << target
      end
    end
  end
end

FINAL_MODULES = %w[ln db vq tf].freeze

# PART I

modules = parse_modules(input)

counts = { low: 0, high: 0 }
1000.times do
  press_button(modules, counts, 0)
end

p counts[:high] * counts[:low]

# PART II

modules = parse_modules(input)

i = 1
until counts.size == 6
  press_button(modules, counts, i)

  i += 1
end

p counts.slice(*FINAL_MODULES).values.reduce(:lcm)
