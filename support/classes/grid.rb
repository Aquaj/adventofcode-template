require 'delegate'
require_relative '../patches'

# Wraps a 2D array
class Grid < SimpleDelegator
  attr_reader :width, :height

  def initialize(twod_array)
    super
    @height = twod_array.length
    @width = twod_array.first.length
  end

  def inspect
    (0...@height).map do |row_i|
      self[row_i].map { |e| e || ' ' }.join
    end.join("\n")
  end

  def coords
    (0...@width).product(0...@height)
  end

  def neighbors_of(*coords, diagonals: false)
    offsets = [[1,0],[0,1],[-1,0],[0,-1]]
    offsets += [[1,1],[-1,1],[1,-1],[-1,-1]] if diagonals
    offsets.map { |(x,y)| [coords.first+x, coords.last+y] }.reject { |(x,y)| out_of_bounds?(x,y) }
  end
  alias_method :neighbors, :neighbors_of

  def out_of_bounds?(x,y)
    x < 0 || x >= @width ||
      y < 0 || y >= @height
  end

  def [](*coords)
    return super(coords.first) if coords.one?
    x,y = *coords
    return nil if out_of_bounds?(x,y)
    self[y][x]
  end

  def []=(*coords, value)
    return super(coords.unwrap, value) if coords.one?
    x,y = *coords
    raise ArgumentError, "#{coords.inspect} is not in grid" if out_of_bounds?(x,y)
    self[y][x] = value
  end

  def concat_h(grid_or_array)
    Grid.new self.to_a.concat_h(grid_or_array.to_a)
  end

  def concat_v(grid_or_array)
    Grid.new self.to_a.concat_v(grid_or_array.to_a)
  end

  def bfs_traverse(to_visit=nil, queue=[], discovered=Set.new(to_visit), &block)
    return discovered unless to_visit

    yield self[*to_visit], to_visit if block_given?

    neighbors_of(*to_visit).reject { |x, y| self[x,y].nil? || discovered.include?([x,y]) }.uniq.
      each do |coord|
        discovered << coord
        queue << coord
      end
    bfs_traverse(queue.shift, queue, discovered, &block)
  end

  def dfs_traverse(to_visit=[0,0], discovered=Set.new, &block)
    discovered << to_visit

    yield self[*to_visit], to_visit if block_given?

    neighbors_of(*to_visit).each do |neighbor|
      next if self[*neighbor].nil? || discovered.include?(neighbor)
      dfs_traverse(neighbor, discovered, &block)
    end

    discovered
  end

  module GraphMethods
    def nodes
      @nodes ||= coords.to_a
    end

    def edges
      @edges ||= coords.flat_map { |s| neighbors_of(*s).map { |t| [s, t] } }
    end

    def edge_cost(_source, target)
      self[*target]
    end

    def neighbors(node)
      super(*node, diagonals: diagonals?)
    end
  end

  def to_graph(diagonals: false)
    graph = Grid.new self.to_a
    graph.extend(GraphMethods)
    graph.define_singleton_method(:diagonals?) {  diagonals }
    graph
  end
end
