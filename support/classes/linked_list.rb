require_relative '../patches'

# Inspired by RubyGems's Gem::List [implem](https://github.com/rubygems/rubygems/blob/master/lib/rubygems/util/list.rb)
class LinkedList
  include Enumerable

  attr_accessor :tail, :head
  attr_reader :value, :length, :last, :first, :links

  def initialize(value, tail = nil)
    @value = value
    @tail = tail
    if tail
      @first = self
      tail.head = self
      @last = tail.last
      @links = tail.links.tap do |l|
        l[value] ||= []
        l[value] << self
      end
      @length = tail.length + 1
    else
      @length = 1
      @head = nil
      @last = self
      @links = { value => [self] }
    end
  end

  def each
    n = self
    while n
      yield n.value, n
      n = n.tail
    end
  end

  def take(*,**)
    super.map(&:first)
  end

  def prepend(value, lazy: false)
    self.class.new(value, self).tap do |list|
      list.propagate_caches unless lazy
    end
  end

  def propagate_caches
    curr = tail
    until curr.nil?
      curr.first = self.first
      curr.length = self.length
      curr = curr.tail
    end
  end

  protected

  attr_writer :length, :first
end
