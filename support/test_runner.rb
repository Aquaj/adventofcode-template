class TestRunner
  SUCCESS_MESSAGE = "%{part} - (%{expected}: %{actual}) ✔ "
  FAILURE_MESSAGE = "%{part} - (%{expected}: %{actual}) ⓧ "

  def initialize(advent_day)
    @day_solver = advent_day
  end

  attr_reader :day_solver

  def run
    test_results = [1, 2].map do |part|
      actual = actual_results[part]
      expected = expected_results[part]

      info = { part: part, expected: expected.inspect, actual: actual.inspect }
      if actual&.to_i == expected&.to_i
        (SUCCESS_MESSAGE % info).green
      else
        (FAILURE_MESSAGE % info).red
      end
    end

    puts "EXAMPLES: ".bold+"#{test_results.join(' | '.bold) }"
    puts
  end

  def actual_results
    @actual_results ||= { 1 => test_instance.first_part, 2 => test_instance.second_part }
  end

  def test_instance
    day_solver.new.tap(&:debug!)
  end

  # --test followed by space followed by 1 or 2 word-likes separated by a comma
  EXPECTED_RESULTS_FLAG_FORMAT = /#{FLAGS[:test]} (\w+)(?:,(\w+))?/

  def expected_results
    return @expected_results if @expected_results

    extracted_from_args = ARGV.join(' ').match(EXPECTED_RESULTS_FLAG_FORMAT)

    @expected_results =
      case
      when extracted_from_args # CLI args take priority over anything else
        { 1 => extracted_from_args[1], 2 => extracted_from_args[2] }.
          transform_values { |v| v&.to_i }
      when defined?(day_solver::EXPECTED_RESULTS)
        day_solver::EXPECTED_RESULTS
      else
        raise "Cannot run test without expected values"
      end
  end
end
