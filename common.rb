require 'bundler'
require 'dotenv/load'

Bundler.require

FLAGS = {
  test: '--test',
  copy: '--copy',
  debug: '--debug',
  no_color: '--no-color',
}

String.disable_colorization = ARGV.include?(FLAGS[:no_color]) || ENV['COLOR'] == 'false'

require_relative 'support/advent_day'
require_relative 'support/patches'
require_relative 'support/setup'

require_relative 'support/classes/grid'
