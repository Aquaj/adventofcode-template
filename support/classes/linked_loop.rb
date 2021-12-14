require_relative '../patches'
require_relative 'linked_list'

class LinkedLoop < LinkedList
  include Enumerable

  def prepend(*,**)
    raise "Already finalized" if @finalized
    super
  end

  def finalize!
    @finalized = true
    propagate_caches
    @last.tail = self
  end
end
