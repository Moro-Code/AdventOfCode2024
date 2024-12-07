class Map
    attr_reader :width, :height
    def initialize(file_path)
        @map = File.open(file_path).readlines.map(&:chomp).map { |line| line.split("") }
        @height = @map.length
        @width = @map[0].length
    end

    def get_row(index)
        return @map[index]
    end

    def coordinate_is_obsticle(coordinate)
        row, column = coordinate
        return @map[row][column] == "#"
    end

    def coordinate_is_gaurd(coordinate)
        row, column = coordinate
        return @map[row][column] == "^"
    end

    def can_place_obsticle(coordinate)
        row, column = coordinate
        if !coordinate_is_obsticle(coordinate) && !coordinate_is_gaurd(coordinate)
            return true
        end
        return false
    end

    def place_obsticle(coordinate)
        row, column = coordinate
        if !coordinate_is_obsticle(coordinate) && !coordinate_is_gaurd(coordinate)
            @map[row][column] = "#"
        else
            return false
        end
        return true
    end 

    def coordinate_is_out_of_bounds(coordinate)
        row, column = coordinate
        return row < 0 || row >= @height || column < 0 || column >= @width
    end
end

class Gaurd
    attr_reader :positions_moved, :out_of_bounds, :cycle_detected
    def initialize(map)
        @current_position = [0, 0]
        @starting_position = [0, 0]
        @direction = "up"
        @positions_moved = []
        @out_of_bounds = false
        @cycle_detected = false
        @moved = false
        for row_index in 0 .. map.width - 1
            column_index = map.get_row(row_index).find_index("^")
            if column_index
                @current_position = [row_index, column_index]
                @starting_position = [row_index, column_index]
                @positions_moved.push(@current_position)
            end
        end
    end

    def turn
        case @direction
            when "up"
                @direction = "right"
            when "right"
                @direction = "down"
            when "down"
                @direction = "left"
            when "left"
                @direction = "up"
        end
    end

    def determine_if_infinite_loop(map)
        return @positions_moved.length > map.width * map.height
    end

    def move(map)
        row, column = @current_position
        case @direction
            when "up"
                row -= 1
            when "right"
                column += 1
            when "down"
                row += 1
            when "left"
                column -= 1
        end
        @cycle_detected = determine_if_infinite_loop(map)
        if !map.coordinate_is_out_of_bounds([row, column]) && !map.coordinate_is_obsticle([row, column])
            @current_position = [row, column]
            @positions_moved.push(@current_position)
            @moved = true
        elsif !map.coordinate_is_out_of_bounds([row, column]) && map.coordinate_is_obsticle([row, column])
            turn
        else
            @positions_moved.push(@current_position)
            @out_of_bounds=true
        end
    end
end