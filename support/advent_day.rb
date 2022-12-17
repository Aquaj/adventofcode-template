require 'benchmark'

require_relative 'test_runner'
require_relative 'input_fetcher'

class AdventDay
  YEAR = ENV['YEAR']

  class << self
    def solve
      return validate if validating?

      run_tests if test?
      results = main_solve
      Clipboard.copy(results[copy_to]) if copy?
    end

    def main_solve
      results = {}
      puts " - #{(Benchmark.measure { print "#1. #{(results[1] = self.new.run(1)).inspect.bold}" }.real * 1000).round(3)}ms"
      puts " - #{(Benchmark.measure { print "#2. #{(results[2] = self.new.run(2)).inspect.bold}" }.real * 1000).round(3)}ms"
    end

    def run_tests
      TestRunner.new(self).run
    end

    def validate
      exit run_tests ? 0 : 1
    rescue TestRunner::MissingTestExpectations
      main_solve
      exit 0
    end

    # --copy followed by space followed by 1 or 2 word-likes separated by a comma
    COPY_FLAG_FORMAT = /#{FLAGS[:copy]} (\d)/
    def copy_to
      match = ARGV.join(' ').match(COPY_FLAG_FORMAT)
      return unless match
      match[1].to_i
    end
    alias_method :copy?, :copy_to

    def test?
      !debug? && (ARGV.include?(FLAGS[:test]) || defined?(self::EXPECTED_RESULTS))
    end

    def debug?
      validating? || ARGV.include?(FLAGS[:debug])
    end

    def validating?
      ARGV.include? FLAGS[:validate]
    end
  end

  attr_reader :part
  def run(part)
    @part = part
    case part
    when 1 then first_part
    when 2 then second_part
    end
  end

  def first_part; end
  def second_part; end

  def convert_data(data)
    data.split("\n")
  end

  def input
    return @input if defined?(@input)
    # Using hooks instead of calling InputFetcher directly to allow override
    input_data = debug? ? debug_input : source_input
    @input ||= convert_data(input_data)
  end

  def input_fetcher
    InputFetcher.new(day_number, YEAR, debug: debug?)
  end

  # HOOK for subclass override
  def source_input
    input_fetcher.get
  end

  # HOOK for subclass override
  def debug_input
    input_fetcher.get
  end

  def display(value)
    puts value unless debug? && test?
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
