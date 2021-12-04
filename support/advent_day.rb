require 'benchmark'

require_relative 'test_runner'
require_relative 'input_fetcher'

class AdventDay
  YEAR = ENV['YEAR']

  class << self
    def solve
      run_tests if test?
      puts " - #{(Benchmark.measure { print "#1. #{self.new.first_part.inspect}"  }.real * 1000).round(3)}ms"
      puts " - #{(Benchmark.measure { print "#2. #{self.new.second_part.inspect}" }.real * 1000).round(3)}ms"
    end

    def run_tests
      TestRunner.new(self).run
    end

    def test?
      ARGV.include?(FLAGS[:test]) || defined?(self::EXPECTED_RESULTS)
    end

    def debug?
      ARGV.include? FLAGS[:debug]
    end
  end

  def first_part; end
  def second_part; end

  def convert_data(data)
    data.split("\n")
  end

  def input
    return @input if defined?(@input)
    # Using hook methods instead of calling InputFetcher directly
    input_data = debug? ? debug_input : source_input
    @input ||= convert_data(input_data)
  end

  # HOOK for subclass override
  def source_input
    InputFetcher.new(day_number, YEAR, debug: false).get
  end

  # HOOK for subclass override
  def debug_input
    InputFetcher.new(day_number, YEAR, debug: true).get
  end

  def debug!
    @debug = true
  end

  def test?
    self.class.test?
  end

  def debug?
    @debug || self.class.debug?
  end

  def day_number
    @day_number ||= self.class.name.gsub('Day', '')
  end
end
