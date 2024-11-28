# frozen_string_literal: true

# https://adventofcode.com/2021/day/16

input = File.read('inputs/16.txt')

bin = input.hex.to_s(2).rjust(input.size * 4, '0')

Packet = Struct.new(:ver, :type, :val, :subpackets, :len)

def parse_packet(bin)
  ver  = bin[0..2].to_i(2)
  type = bin[3..5].to_i(2)

  if type == 4
    pos      = 6
    val_bits = ''

    loop do
      chunk = bin[pos..pos + 4]

      val_bits += chunk[1..4]
      pos += 5

      break if chunk[0] == '0'
    end

    Packet.new(ver, type, val_bits.to_i(2), [], pos)
  else
    len_type = bin[6]

    if len_type == '0'
      total_len  = bin[7..21].to_i(2)
      pos        = 22
      subpackets = []
      end_pos    = pos + total_len

      while pos < end_pos
        subpacket = parse_packet(bin[pos..])
        subpackets << subpacket
        pos += subpacket.len
      end
    else
      num_packets = bin[7..17].to_i(2)
      pos         = 18
      subpackets  = []

      num_packets.times do
        subpacket = parse_packet(bin[pos..])
        subpackets << subpacket
        pos += subpacket.len
      end
    end

    Packet.new(ver, type, nil, subpackets, pos)
  end
end

packet = parse_packet(bin)

# PART I

def sum_of_versions(packet)
  packet.ver + packet.subpackets.sum { |sp| sum_of_versions(sp) }
end

p sum_of_versions(packet)

# PART II

def packet_value(packet)
  vals = packet.subpackets.map { |sp| packet_value(sp) }

  case packet.type
  when 0 then vals.sum
  when 1 then vals.reduce(:*)
  when 2 then vals.min
  when 3 then vals.max
  when 4 then packet.val
  when 5 then vals[0] > vals[1] ? 1 : 0
  when 6 then vals[0] < vals[1] ? 1 : 0
  when 7 then vals[0] == vals[1] ? 1 : 0
  end
end

p packet_value(packet)
