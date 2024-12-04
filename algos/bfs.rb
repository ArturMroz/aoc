def bfs(graph, start, target)
  q    = [start]
  seen = Set.new([start])
  prev = {}

  until q.empty?
    nq = []

    q.each do |cur|
      graph[cur].each do |neighbour|
        next if seen.include?(neighbour)

        seen << neighbour

        prev[neighbour] = cur

        if neighbour == target
          path = []
          while target
            path << target
            target = prev[target]
          end

          return path
        end

        nq << neighbour
      end
    end

    q = nq
  end
end
