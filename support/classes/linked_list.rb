require_relative '../patches'

class LinkedList
  include Enumerable

  attr_reader :length, :last, :first, :links

  def initialize(collection, lazy: true)
    @links = collection.
      map { |element| Link.new element }.
      each_cons(2) { |head,tail| head.tail, tail.head = tail, head }

    @first = @links.first
    @last = @links.last
    @length = collection.length
  end

  def loop!
    @last.tail = @first
    @first.head = @last
  end

  def inspect
    to_a.map { |e,_| "[#{e.inspect}]" }.join(" => ")
  end

  def remove(link)
    prev_link, next_link = link.head, link.tail

    prev_link.tail = next_link if prev_link
    next_link.head = prev_link if next_link

    @length -= 1
    @first = next_link if @first == link
    @last = prev_link if @last == link

    link
  end

  def each
    curr = @first
    while curr
      yield curr.value, curr
      curr = curr.tail
    end
  end

  def to_a
    (@length - 1).times.reduce([@first]) { |a,_| a << a.last.tail }
  end

  def move(link, diff, loop: true)
    start = link.head # New starting point since we're removing the link
    remove(link)

    diff %= @length if loop
    next_head = start.next(diff)

    append(link, next_head) # Putting it back in
    link
  end

  def append(link, prev_link)
    next_link = prev_link.tail
    insert_between(prev_link, next_link, link)
    @last = link if @last == prev_link
    @length += 1
    link
  end

  def prepend(link, next_link)
    prev_link = next_link.head
    insert_between(prev_link, next_link, link)
    @first = link if @first == next_link
    link
  end

  def insert_between(prev_link, next_link, link)
    prev_link.tail = link if prev_link
    next_link.head = link if next_link
    link.head = prev_link
    link.tail = next_link
    link
  end

  class Link
    include Enumerable

    attr_accessor :tail, :head
    attr_reader :value

    def initialize(value, tail = nil)
      @value = value
      @tail = tail
    end

    def inspect
      value.inspect
    end

    def next(diff)
      diff.times.reduce(self) { |curr,_| curr.tail || raise("Can't move beyond end of list") }
    end

    def previous(diff)
      diff.times.reduce(self) { |curr,_| curr.head || raise("Can't move before beginning of list") }
    end

    protected

    attr_writer :length, :first
  end
end
