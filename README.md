# advent-of-code-template
[Advent of Code 🎄](https://adventofcode.com) solving framework by `@Aquaj`

This repository template provides:
- some common useful libraries (run `bundle install` to fetch them)
- a clean README in the eventuality you'd make your solutions public afterwards (see [Usable README](#usable-readme))
- a simple way to interact with the Advent of Code problems (with the AdventDay class) (see [The day-xx.rb
    files](#the-day-xxrb-files))
- some gneral-purposes standard lib enhancements (see [Utility Methods](#utility-methods))

## ENV

To run properly the framework needs two specific variables in your environment:
- `YEAR` needs to contain the year we're fetching the exercises and inputs from
- `SESSION` needs to contain a valid session cookie value for [adventofcode.com](https://adventofcode.com) - which you
    can find by logging in and using developer tools (in the "Storage" tab or your browser's equivalent)

A `.env.template` you can complete and rename into `.env` is provided, the gem `dotenv` is setup on the project to
facilitate their manipulation.

## The day-xx.rb files

Each file for the 25 days of the AoC are prefilled with an empty AdventDay template consisting of three parts:
- The `#first_part` method is meant to hold the code to your solution to the first challenge of the day
- The `#second_part` method is meant to hold the code to your solution to the second challenge of the day
- The `#convert_data` method will be used to turn the input from the challenge (dynamically fetched from the website) into
    whatever structure you want it to be. Result of this method call is then accessible through the `#input` method.
    Default (`super`) will simply split line by line.

The first call to `#input` will download the input from AoC's website (provided the `SESSION` env var is set) and store
it in `inputs/<day-number>` to cache it. Those files are not tracked by git.

Running the file (`ruby day-01.rb`) will display the result of your `#first_part` methods, then the result to your
`#second_part` method in order, accompanied each by the time it took to run it.

**Example:**
```ruby
require_relative 'common'

## file contents of input/1
# 123
# 456
# 789

class Day1 < AdventDay
  def first_part
    input.last(2).sum
  end

  def second_part
    input.last(2).map(&:to_s).map(&:reverse).map(&:to_i).sum
  end

  private

  def convert_data(data)
    super.map(&:to_i)
  end
end

Day1.solve
```
```shell
% ruby day-01.rb

1245 - 0.342ms
1641 - 0.108ms
```

## Utility methods

In the `common.rb` file you'll find the AdventDay framework class, and a `Patches` module containing some utility
patches to the standard ruby library that I've found useful to keep at hand during exercises.

Feel free to add your own to it.

## Usable README

At the end of this explanation you'll find a complete README you can use almost-as-is for your own repository if you
decide to make your solutions public once the AoC is over.

To set it up you should:
- replace `@yournamehere` by your own name or pseudonym
- replace all `20xx` occurrences (including in urls) by the year the repository is for
- set up the pitch of the year's AoC storyline in [the appropriate section](#advent-of-code-story)

The README also holds a table recapping the repository's solutions content.

Each time an exercise is published you can set its actual name instead of the TBD in the `Day` column, then put a golden
star emoji `🌟` in the appropriate `Part` column when completing it. When working on the solution you can put an hourglassemoji `⏳` in the first column, and replace it with a checkmark emoji `✔️` once you're done with both solutions.

For convenience all 3 emojis are stored in an HTML comment above the table, you only need to copy-paste the appropriate
one in its place.

# Once setup and ready to publish, delete everything before this line including this title

-----------------------------------------

# advent-of-code-20xx
[Advent of Code 20xx 🎄](https://adventofcode.com/year/20xx) solutions by `@yournamehere`

README is based on [Jérémie Bonal's AoC Ruby template](https://github.com/aquaj/adventofcode-template).

[![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## What is Advent of Code?
[Advent of Code](http://adventofcode.com) is an online event created by [Eric Wastl](https://twitter.com/ericwastl).
Each year, starting on Dec 1st, an advent calendar of small programming puzzles are unlocked once a day at midnight
(EST/UTC-5). Developers of all skill sets are encouraged to solve them in any programming language they choose!

## Advent of Code Story

**TODO: Fill in with story pitch from the text of Day 1's challenge**

**These were not written as example of clean or efficient code** but are simply my attempts at finding the answers to
each day's puzzle as quickly as possible. Performance logging was added simply as a fun way to compare implementations
with other competitors.

## Puzzles

<!-- On-hand emojis: ⏳ ✔ 🌟 -->
|| Day  | Part One | Part Two | Solutions
|:---:|---|:---:|:---:|:---:|
|   |[Day 1: TBD](https://adventofcode.com/20xx/day/1)|    |    |[Solution](day-01.rb)
|   |[Day 2: TBD](https://adventofcode.com/20xx/day/2)|    |    |[Solution](day-02.rb)
|   |[Day 3: TBD](https://adventofcode.com/20xx/day/3)|    |    |[Solution](day-03.rb)
|   |[Day 4: TBD](https://adventofcode.com/20xx/day/4)|    |    |[Solution](day-04.rb)
|   |[Day 5: TBD](https://adventofcode.com/20xx/day/5)|    |    |[Solution](day-05.rb)
|   |[Day 6: TBD](https://adventofcode.com/20xx/day/6)|    |    |[Solution](day-06.rb)
|   |[Day 7: TBD](https://adventofcode.com/20xx/day/7)|    |    |[Solution](day-07.rb)
|   |[Day 8: TBD](https://adventofcode.com/20xx/day/8)|    |    |[Solution](day-08.rb)
|   |[Day 9: TBD](https://adventofcode.com/20xx/day/9)|    |    |[Solution](day-09.rb)
|   |[Day 10: TBD](https://adventofcode.com/20xx/day/10)|    |    |[Solution](day-10.rb)
|   |[Day 11: TBD](https://adventofcode.com/20xx/day/11)|    |    |[Solution](day-11.rb)
|   |[Day 12: TBD](https://adventofcode.com/20xx/day/12)|    |    |[Solution](day-12.rb)
|   |[Day 13: TBD](https://adventofcode.com/20xx/day/13)|    |    |[Solution](day-13.rb)
|   |[Day 14: TBD](https://adventofcode.com/20xx/day/14)|    |    |[Solution](day-14.rb)
|   |[Day 15: TBD](https://adventofcode.com/20xx/day/15)|    |    |[Solution](day-15.rb)
|   |[Day 16: TBD](https://adventofcode.com/20xx/day/16)|    |    |[Solution](day-16.rb)
|   |[Day 17: TBD](https://adventofcode.com/20xx/day/17)|    |    |[Solution](day-17.rb)
|   |[Day 18: TBD](https://adventofcode.com/20xx/day/18)|    |    |[Solution](day-18.rb)
|   |[Day 19: TBD](https://adventofcode.com/20xx/day/19)|    |    |[Solution](day-19.rb)
|   |[Day 20: TBD](https://adventofcode.com/20xx/day/20)|    |    |[Solution](day-20.rb)
|   |[Day 21: TBD](https://adventofcode.com/20xx/day/21)|    |    |[Solution](day-21.rb)
|   |[Day 22: TBD](https://adventofcode.com/20xx/day/22)|    |    |[Solution](day-22.rb)
|   |[Day 23: TBD](https://adventofcode.com/20xx/day/23)|    |    |[Solution](day-23.rb)
|   |[Day 24: TBD](https://adventofcode.com/20xx/day/24)|    |    |[Solution](day-24.rb)
|   |[Day 25: TBD](https://adventofcode.com/20xx/day/25)|    |    |[Solution](day-25.rb)

## Running the code

Run `bundle install` to install any dependencies.

Each day computes and displays the answers to both of the day questions and their computing time in ms. To run it type `ruby day<number>.rb`.

If the session cookie value is provided through the SESSION env variable (dotenv is available to provide it) — it will
fetch the input from the website and store it as a file under the `inputs/` folder on its first run.
Lack of a SESSION value will cause the code to raise an exception unless the input file (`inputs/{number}`) already
present. The code will also raise if the input isn't available from AoC's website (`404` error).
