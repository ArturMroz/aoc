# https://adventofcode.com/2023/day/5

input = File.read('inputs/05.txt').split("\n\n")

seeds = input[0].split.drop(1).map(&:to_i)

# PART I

next_mapping = seeds

input.drop(1).each do |group|
  mapping_ranges = group.lines.drop(1).map do |line|
    dst, src, len = line.split.map(&:to_i)
    [(src..src + len - 1), src - dst]
  end

  next_mapping = next_mapping.map do |seed_loc|
    mapped_loc = mapping_ranges.find { |r, _| r.cover?(seed_loc) }
    mapped_loc ? seed_loc - mapped_loc[1] : seed_loc
  end
end

p next_mapping.min

# PART II

next_mapping = seeds
  .each_slice(2)
  .map { |start, len| (start..start + len) }

input.drop(1).each do |group|
  mapping_ranges = group.lines.drop(1).map do |line|
    dst, src, len = line.split.map(&:to_i)
    [(src..src + len - 1), src - dst]
  end

  next_mapping = next_mapping.flat_map do |seed_range|
    queue  = [seed_range]
    result = []

    until queue.empty?
      cur_seed_range    = queue.pop
      mapped_seed_range = nil

      mapping_ranges.each do |r, shift|
        if r.cover?(cur_seed_range)
          mapped_seed_range = (cur_seed_range.begin - shift..cur_seed_range.end - shift)
        elsif r.cover?(cur_seed_range.begin) && !r.cover?(cur_seed_range.end)
          mapped_seed_range = (cur_seed_range.begin - shift..r.end - shift)
          queue << (r.end + 1..cur_seed_range.end)
        elsif !r.cover?(cur_seed_range.begin) && r.cover?(cur_seed_range.end)
          mapped_seed_range = (r.begin - shift..cur_seed_range.end - shift)
          queue << (cur_seed_range.begin..r.begin - 1)
        elsif cur_seed_range.cover?(r)
          mapped_seed_range = (r.begin - shift..r.end - shift)
          queue << (cur_seed_range.begin..r.begin - 1)
          queue << (r.end + 1..cur_seed_range.end)
        end
        break if mapped_seed_range
      end

      result << (mapped_seed_range || cur_seed_range)
    end

    result
  end
end

p next_mapping.map(&:begin).min
