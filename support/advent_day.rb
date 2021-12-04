require 'benchmark'

require_relative 'input_fetcher'

class AdventDay
  YEAR = ENV['YEAR']
  DEBUG_FLAG = '--debug'

  def self.solve
    puts " - #{(Benchmark.measure { print self.new.first_part.inspect  }.real * 1000).round(3)}ms"
    puts " - #{(Benchmark.measure { print self.new.second_part.inspect }.real * 1000).round(3)}ms"
  end

  def first_part; end
  def second_part; end

  def convert_data(data)
    data.split("\n")
  end

  def input
    return @input if defined?(@input)
    input_data = InputFetcher.new(day_number, YEAR, debug: debug?).get
    @input ||= convert_data(input_data)
  end

  def debug?
    return @debug if defined?(@debug)
    @debug = ARGV.include? DEBUG_FLAG
  end

  def day_number
    @day_number ||= self.class.name.gsub('Day', '')
  end
end
