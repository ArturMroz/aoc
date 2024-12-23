# https://adventofcode.com/2024/day/22

input = File.read('inputs/22.txt').split("\n").map(&:to_i)

def next_secret(secret)
  secret = ((secret * 64)   ^ secret) % 16_777_216
  secret = ((secret / 32)   ^ secret) % 16_777_216
  secret = ((secret * 2048) ^ secret) % 16_777_216

  secret
end

secrets_sum     = 0
prices_by_diffs = Hash.new { |h, k| h[k] = [] }

input.each do |secret|
  last_price = secret % 10
  diffs      = []
  seen       = Set.new

  2000.times do
    secret    = next_secret(secret)
    cur_price = secret % 10

    diffs << (cur_price - last_price)

    last_price = cur_price

    if diffs.size == 4
      last_four_hash = diffs.hash

      # sale happens on the first appearance of a sequence so we need to ignore later appearances
      unless seen.include?(last_four_hash)
        prices_by_diffs[last_four_hash] << cur_price
        seen << last_four_hash
      end

      diffs.shift
    end
  end

  secrets_sum += secret
end

# PART I
p secrets_sum

# PART II
p prices_by_diffs.values.map(&:sum).max
