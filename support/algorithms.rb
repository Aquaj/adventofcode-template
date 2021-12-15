require 'algorithms'

module Algorithms
  extend self
  include Containers

  def dijkstra(source, graph, goal = nil)
    visited = Set.new
    distance={}.with_default Float::INFINITY
    previous={}.with_default nil
    costs = PriorityQueue.new

    distance[source] = 0

    unvisited_node = graph.nodes
    costs.push(source, 0)

    until costs.empty?
      u = costs.pop
      visited << u

      break if (distance[u] == Float::INFINITY)
      break if goal && u == goal

      graph.neighbors(u).each do |vertex|
        next if visited.include? vertex

        alt = distance[u] + graph.edge_cost(u, vertex)

        if (alt < distance[vertex])
          distance[vertex] = alt
          previous[vertex] = u
          costs.push(vertex, -alt)
        end
      end
    end

    { distances: distance, previous: previous }
  end

  def bellman_ford(source, graph)
    distance={}.with_default Float::INFINITY
    previous={}.with_default nil

    distance[source] = 0

    edge_list = graph.edges

    graph.coords.each do |_|
      edge_list.each do |edge|
        cost = distance[edge.first] + graph.edge_cost(*edge)
        next unless distance[edge.last] > cost
        distance[edge.last] = cost
        previous[edge.last] = edge.first
      end
    end
    { distances: distance, previous: previous }
  end

  def paths_from(previous:, goal:)
    return nil unless previous.include? goal

    parent = goal
    path = []
    until parent.nil?
      path << parent
      parent = previous[parent]
    end
    path
  end
end
