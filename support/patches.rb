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

  module EnumMath
    def average(&block)
      self.sum(&block).to_f / self.count
    end
    alias_method :mean, :average

    def median(&block)
      return nil if self.count == 0
      sorted = self.sort
      sorted = sorted.map(&block) if block
      (sorted[(self.count - 1) / 2] + sorted[self.count / 2]) / 2.0
    end

    def geometric_mean(&block)
      coll = self.map(&(block || :itself))
      sum = coll.reduce(0) { |memo, v| memo + Math.log(v) }
      sum /= coll.count
      Math.exp(sum)
    end
    alias_method :gmean, :geometric_mean
  end
  Enumerable.include EnumMath

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

  module ReverseHash
    class NotReversableError < StandardError; end

    def reverse
      raise NotReversableError unless values.uniq == values
      self.map(&:reverse).to_h
    end
  end
  Hash.include ReverseHash

end
