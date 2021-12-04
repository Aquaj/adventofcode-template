require 'faraday'
require 'net/http'

class InputFetcher
  SESSION = ENV['SESSION']

  attr_reader :day_number, :year

  def initialize(day_number, year)
    @day_number = day_number
    @year = year
  end

  def get
    return File.read(file_path) if file_path.exist?
    download_input
  end

  def file_path
    Pathname.new('inputs/'+day_number)
  end

  INPUT_BASE_URL = 'https://adventofcode.com'.freeze
  INPUT_PATH_SCHEME = '/%{year}/day/%{number}/input'.freeze

  def download_input
    raise "Cannot download input without a session cookie" unless SESSION
    res = Faraday.get(
      INPUT_BASE_URL + INPUT_PATH_SCHEME % { year: year, number: day_number },
      nil,
      { 'Cookie' => "session=#{SESSION}" },
    )
    raise "Input doesn't appear to be accessible (yet?)" if res.status == 404
    File.write('inputs/'+day_number, res.body)
    res.body
  end
end
