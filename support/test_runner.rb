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

      info = { part: part, expected: expected.inspect, actual: actual.inspect, success?: compare(actual, expected)}
    end

    result_messages = test_results.map do |info|
      if info[:success?]
        (SUCCESS_MESSAGE % info).green
      else
        (FAILURE_MESSAGE % info).red
      end
    end
    puts "EXAMPLES: ".bold+"#{result_messages.join(' | '.bold) }"
    puts

    test_results.all? { |test| test[:success?] }
  end

  def compare(answer, expected)
    is_expected_num = (expected.to_i.to_s == expected.to_s)

    if is_expected_num
      numerical_answer = answer.respond_to?(:to_i) ? answer.to_i : answer
      numerical_answer == expected&.to_i
    else
      answer == expected
    end
  end

  def actual_results
    @actual_results ||= {
      1 => test_instance.run(1),
      2 => test_instance.run(2),
    }
  end

  def test_instance
    day_solver.new.tap(&:debug!)
  end

  class MissingTestExpectations < StandardError; end
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
        raise MissingTestExpectations, "Cannot run test without expected values"
      end
  end
end
