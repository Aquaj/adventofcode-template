require 'faraday'
require 'net/http'

class InputFetcher
  SESSION = ENV['SESSION']
  INPUT_FILE_NAME_FORMAT = 'inputs/%{number}'
  DEBUG_FILE_NAME_FORMAT = 'inputs/debug-%{number}'

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
      download_debug_input
    else
      download_input
    end
  end

  def file_path
    if debug?
      debug_file_path
    else
      source_file_path
    end
  end

  def source_file_path
    Pathname.new(INPUT_FILE_NAME_FORMAT % { number: day_number })
  end

  def debug_file_path
    Pathname.new(DEBUG_FILE_NAME_FORMAT % { number: day_number })
  end

  AOC_BASE_URL = 'https://adventofcode.com'.freeze
  PUZZLE_PATH_SCHEME = '/%{year}/day/%{number}'.freeze
  INPUT_PATH_SCHEME = "#{PUZZLE_PATH_SCHEME}/input".freeze

  def download_input
    res = fetch(AOC_BASE_URL + INPUT_PATH_SCHEME % { year: year, number: day_number })
    File.write(source_file_path, res.body)
    res.body
  end

  def download_debug_input
    raise "Can't run debug mode without debug input #{file_path}"
  end

  def fetch(path)
    raise "Cannot download without a session cookie" unless SESSION
    res = Faraday.get(
      path,
      nil,
      { 'Cookie' => "session=#{SESSION}" },
    )
    raise "Page doesn't appear to be accessible (yet?)" if res.status == 404
    res
  end
end
