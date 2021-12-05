module Patches
  module Every
    def every(n)
      self.lazy.with_index.select { |_e, i| i % n == 0 }.map { |e,i| e }.eager
    end
  end
  Array.include Every

  module Nth
    def nth(n)
      n.times do |count|
        val = self.next
        break val if count == n-1
      end
    end
  end
  Enumerator.include Nth

  module Product
    def product(enum)
      Enumerator.new do |yielder|
        self.each do |a|
          enum.each do |b|
            yielder << [a, b]
          end
        end
      end
    end
  end
  Enumerable.include Product

  module Towards
    def towards(num)
      return self.downto(num) if self > num
      self.upto(num)
    end
  end
  Numeric.include Towards

  module ConvenientAccess
    def first
      chars.first
    end

    def last
      chars.last
    end
  end
  String.include ConvenientAccess

  module Without
    def without(*keys)
      reject { |k,_| keys.include? k }.to_h
    end
  end
  Hash.include Without

  module DeepCopy
    def deep_copy
      Marshal.load(Marshal.dump(self))
    end
  end
  Object.include DeepCopy

  module Unwrap
    class NotUnwrappableError < StandardError; end

    def unwrap
      raise NotUnwrappableError unless self.length == 1
      self.first
    end
  end
  Set.include Unwrap
  Array.include Unwrap
end
