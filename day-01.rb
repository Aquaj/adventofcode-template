require_relative 'common'

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

  def debug_input
    "12\n34\n56"
  end
end

Day1.solve
