class Setup
  TEMPLATE = <<~RUBY.freeze
    require_relative 'common'

    class Day%{number} < AdventDay
      def first_part
      end

      def second_part
      end

      private

      def convert_data(data)
        super
      end
    end

    Day%{number}.solve
  RUBY

  def self.run
    created_files = (1..25).map do |n|
      filename = "day-#{n.to_s.rjust(2, '0')}.rb"
      next if File.exists? filename
      File.write(filename, TEMPLATE % { number: n })
      filename
    end.compact
    if created_files.any?
      puts "Created the following files: \n#{created_files.map { |file| " - #{file}" }.join("\n")}"
    else
      puts "No file to create."
    end
  end
end

if $0 == __FILE__
  Setup.run
end
