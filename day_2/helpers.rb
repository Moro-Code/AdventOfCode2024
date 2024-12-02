class Levels
    def initialize(file_path)
        @file_path = file_path
        file = File.open(@file_path)
        level_lines = file.readlines.map(&:chomp)
        @levels = level_lines.map { |x| x.split(' ').map(&:to_i) }
    end

    def calculate_safety_for_level_pair(last_value, value, decreasing)
        if last_value < value && decreasing
            return false
        elsif last_value > value && !decreasing
            return false
        elsif last_value - value == 0 || (last_value - value).abs > 3
            return false
        end
        return true
    end

    def calculate_safety_for_level(level)
        safe = true
        last_value = level[0]
        decreasing = level[0] > level[1]
        for value in level[1..] do
            safe = calculate_safety_for_level_pair(last_value, value, decreasing)
            if !safe
                break
            end
            last_value = value
        end
        return safe
    end

    def calculate_safety
        level_safety_array = []
        for level in @levels do
            safe = calculate_safety_for_level(level)
            current_index = 0
            while !safe && current_index < level.length do
                temp_level = level.dup
                temp_level.delete_at(current_index)
                safe = calculate_safety_for_level(temp_level)
                current_index += 1
            end
            level_safety_array.push(safe)
        end

        return level_safety_array.count(true)
    end
end 