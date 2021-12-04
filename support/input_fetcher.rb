require 'faraday'
require 'net/http'

class InputFetcher
  SESSION = ENV['SESSION']

  attr_reader :day_number, :year
  def debug?; @debug; end

  def initialize(day_number, year, debug: false)
    @day_number = day_number
    @year = year
    @debug = debug
  end

  def get
    return File.read(file_path) if file_path.exist?
    if debug?
      raise "Can't run debug mode without debug input #{file_path}"
    else
      download_input
    end
  end

  def file_path
    if debug?
      Pathname.new('inputs/debug-'+day_number)
    else
      Pathname.new('inputs/'+day_number)
    end
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
