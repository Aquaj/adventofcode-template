require 'delegate'
require_relative '../patches'

# Wraps a 2D array
class Grid < SimpleDelegator
  def initialize(twod_array)
    super
    @height = twod_array.length
    @width = twod_array.first.length
  end

  def coords
    (0...@width).product(0...@height)
  end

  def neighbors_of(*coords)
    offsets = [[1,0],[0,1],[-1,0],[0,-1]]
    offsets.map { |(x,y)| [coords.first+x, coords.last+y] }.reject { |(x,y)| out_of_bounds?(x,y) }
  end

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

  def bfs_traverse(to_visit=nil, queue=[], discovered=[to_visit], &block)
    return discovered unless to_visit

    yield self[*to_visit], to_visit if block_given?

    neighbors_of(*to_visit).reject { |x, y| self[x,y].nil? || discovered.include?([x,y]) }.uniq.
      each do |coord|
        discovered << coord
        queue << coord
      end
    bfs_traverse(queue.shift, queue, discovered, &block)
  end

  def dfs_traverse(to_visit=[0,0], discovered=[], &block)
    discovered << to_visit

    yield self[*to_visit], subtree_root if block_given?

    neighbors_of(*to_visit).each do |neighbor|
      next if self[*neighbor].nil? || discovered.include?(neighbor)
      dfs_traverse(neighbor, discovered, &block)
    end

    discovered
  end
end
