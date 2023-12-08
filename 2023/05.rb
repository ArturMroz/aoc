# https://adventofcode.com/2023/day/5

input = File.read('inputs/05.txt').split("\n\n")

seeds = input[0].scan(/\d+/).map(&:to_i)

# PART I

next_mapping = seeds

input.drop(1).each do |group|
    mapping_ranges = group.lines.drop(1).map do |line|
        dst, src, len = line.scan(/\d+/).map(&:to_i)
        [(src..src + len - 1), src - dst]
    end

    next_mapping = next_mapping.map do |seed_loc|
        mapped_loc = mapping_ranges.find { |r, _| r.cover?(seed_loc) }
        mapped_loc ? seed_loc - mapped_loc[1] : seed_loc
    end
end

p next_mapping.min

# PART II

def merge_ranges(ranges)
    ranges
        .sort_by(&:begin)
        .each_with_object([]) do |cur, result|
            if result.empty? || cur.begin > result.last.end
                result << cur
            elsif result.last.end < cur.end
                result.last.end = cur.end
            end
        end
end

next_mapping = seeds.each_slice(2).map { |start, len| (start..start + len) }

input.drop(1).each do |group|
    mapping_ranges = group.lines.drop(1).map do |line|
        dst, src, len = line.scan(/\d+/).map(&:to_i)
        [(src..src + len - 1), src - dst]
    end

    new_seed_ranges = []

    next_mapping.each do |seed_range|
        queue  = [seed_range]
        result = []

        until queue.empty?
            cur_seed_range    = queue.pop
            mapped_seed_range = nil

            mapping_ranges.each do |r, shift|
                if r.cover?(cur_seed_range.begin) && r.cover?(cur_seed_range.end)
                    mapped_seed_range = (cur_seed_range.begin - shift..cur_seed_range.end - shift)
                elsif r.cover?(cur_seed_range.begin) && !r.cover?(cur_seed_range.end)
                    mapped_seed_range = (cur_seed_range.begin - shift..r.end - shift)
                    queue << (r.end + 1..cur_seed_range.end)
                elsif !r.cover?(cur_seed_range.begin) && r.cover?(cur_seed_range.end)
                    mapped_seed_range = (r.begin - shift..cur_seed_range.end - shift)
                    queue << (cur_seed_range.begin..r.begin - 1)
                elsif cur_seed_range.cover?(r.begin) && cur_seed_range.cover?(r.end)
                    mapped_seed_range = (r.begin - shift..r.end - shift)
                    queue << (cur_seed_range.begin..r.begin - 1)
                    queue << (r.end + 1..cur_seed_range.end)
                end
                break unless mapped_seed_range.nil?
            end

            mapped_seed_range = cur_seed_range if mapped_seed_range.nil?
            result << mapped_seed_range
        end

        new_seed_ranges += result
        new_seed_ranges = merge_ranges(new_seed_ranges)
    end

    next_mapping = new_seed_ranges
end

p next_mapping.map(&:begin).min
