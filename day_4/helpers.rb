class XMASFinder
    def initialize(file_path)
        @xmas_matrix = File.open(file_path).readlines.map(&:chomp).map { |line| line.split("") }
    end

    def calculate_next_diagonal(row_index, column_index, direction)
        case direction
            when "up_right"
                return row_index - 1, column_index + 1
            when "down_right"
                return row_index + 1, column_index + 1
            when "up_left"
                return row_index - 1, column_index - 1
            when "down_left"
                return row_index + 1, column_index - 1
        end
    end

    def determine_xmas_row(row_index, column_index, direction)
        begin
            letters = ""
            for i in 0..3
                if direction == "right"
                    letters += @xmas_matrix[row_index][column_index + i]
                else
                    if column_index - i < 0
                        return false
                    end
                    letters += @xmas_matrix[row_index][column_index - i]
                end
            end
            letters == "XMAS"
        rescue => exception
            return false
        end
    end 

    def determine_xmas_column(row_index, column_index, direction)
        begin
            letters = ""
            for i in 0..3
                if direction == "down"
                    letters += @xmas_matrix[row_index + i][column_index]
                else
                    if row_index - i < 0
                        return false
                    end
                    letters += @xmas_matrix[row_index - i][column_index]
                end
            end
            return letters == "XMAS"
        rescue => exception
            return false
        end
    end

    def determine_xmas_diagonal(row_index, column_index, direction)
        begin
            letters = ""
            for i in 0..3
                if row_index < 0 || column_index < 0
                    return false
                end
                letters += @xmas_matrix[row_index][column_index]
                row_index, column_index = calculate_next_diagonal(row_index, column_index, direction)
            end
            return letters == "XMAS"
        rescue => exception
            return false
        end
    end

    def determine_mas(row_index, column_index)
        begin
            if row_index - 1 < 0 || column_index -1 < 0
                return false
            end
            mas_diagnoal = true
            # diagonal left down and up
            if @xmas_matrix[row_index -1][column_index -1] == "M"
                if @xmas_matrix[row_index + 1][column_index + 1] != "S"
                    mas_diagnoal = false
                end
            elsif @xmas_matrix[row_index -1][column_index -1] == "S"
                if @xmas_matrix[row_index + 1][column_index + 1] != "M"
                    mas_diagnoal = false 
                end
            else
                mas_diagnoal = false
            end

            # diagonal right down and up
            if @xmas_matrix[row_index - 1][column_index +1] == "M"
                if @xmas_matrix[row_index + 1][column_index - 1] != "S"
                    mas_diagnoal = false
                end
            elsif @xmas_matrix[row_index - 1][column_index + 1] == "S"
                if @xmas_matrix[row_index + 1][column_index - 1] != "M"
                    mas_diagnoal = false
                end
            else
                mas_diagnoal = false
            end

            return mas_diagnoal
        rescue => exception 
            return false
        end
    end


    def count_all_mas_instances
        mas_count = 0
        @xmas_matrix.each_with_index {
            |line, row_index|
            all_a_in_row = (0 ... line.length).find_all { |i| line.join()[i, 1] == 'A' }
            for a in all_a_in_row
                if determine_mas(row_index, a)
                    mas_count += 1
                end
            end
        }
        return mas_count
    end
    

    def count_all_xmas_instances
        xmas_count = 0
        print @xmas_matrix
        @xmas_matrix.each_with_index {|line, row_index|
            all_x_in_row = (0 ... line.length).find_all { |i| line.join()[i, 1] == 'X' }
            for x in all_x_in_row
                xmases  = [
                    determine_xmas_row(row_index, x, "right"),
                    determine_xmas_row(row_index, x, "left"),
                    determine_xmas_column(row_index, x, "down"),
                    determine_xmas_column(row_index, x, "up"),
                    determine_xmas_diagonal(row_index, x, "up_right"),
                    determine_xmas_diagonal(row_index, x, "down_right"),
                    determine_xmas_diagonal(row_index, x, "up_left"),
                    determine_xmas_diagonal(row_index, x, "down_left")
                ]
                xmas_count += xmases.count(true)
            end
        }
        return xmas_count
    end
end