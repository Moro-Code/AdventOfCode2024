class Instructions
    attr_reader :file_lines
    attr_reader :instructions
    def initialize(file_path)
        @file_lines = File.open(file_path).readlines.map(&:chomp)
        @instructions = []
        for line in file_lines
            matches = line.scan(/don't\(\)|do\(\)|mul\(\d{1,3},\d{1,3}\)/)
            @instructions.push(matches)
        end
        @instructions.flatten!
    end

    def calculate_sum_of_instructions
        sum = 0
        for instruction in instructions
            numbers = instruction.scan(/\d{1,3}/)
            sum += numbers[0].to_i * numbers[1].to_i
        end
        return sum
    end

    def calculate_enabled_instructions
        is_enabled = true 
        sum = 0 
        for instruction in instructions
            if instruction == "do()"
                is_enabled = true
            elsif instruction == "don't()"
                is_enabled = false
            elsif instruction.include?("mul")
                numbers = instruction.scan(/\d{1,3}/)
                if is_enabled
                    sum += numbers[0].to_i * numbers[1].to_i
                end
            end
        end
        return sum
    end
end