require 'bundler'
require 'dotenv/load'

Bundler.require

FLAGS = {
  test: '--test',
  debug: '--debug',
}

require_relative 'support/advent_day'
require_relative 'support/patches'
require_relative 'support/setup'

if $0 == __FILE__
  Setup.run
end
