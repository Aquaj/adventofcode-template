require 'benchmark'
require 'net/http'

class AdventDay
  SESSION = ENV['SESSION']
  YEAR = ENV['YEAR']

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
    input_path = Pathname.new('inputs/'+day_number)
    input_data = if input_path.exist?
      File.read(input_path)
    else
      download_input
    end
    convert_data(input_data)
  end

  INPUT_BASE_URL = 'https://adventofcode.com'.freeze
  INPUT_PATH_SCHEME = '/%{year}/day/%{number}/input'.freeze

  def download_input
    raise "Cannot download input without a session cookie" unless SESSION
    res = Faraday.get(
      INPUT_BASE_URL + INPUT_PATH_SCHEME % { year: YEAR, number: day_number },
      nil,
      { 'Cookie' => "session=#{SESSION}" },
    )
    raise "Input doesn't appear to be accessible (yet?)" if res.status == 404
    File.write('inputs/'+day_number, res.body)
    res.body
  end

  def day_number
    @day_number ||= self.class.name.gsub('Day', '')
  end
end
