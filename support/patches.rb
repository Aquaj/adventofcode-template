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
