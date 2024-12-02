
class LocationIDs 
    def initialize(file_path)
        @file_path = file_path
        file = File.open(@file_path)
        location_ids = file.readlines.map(&:chomp)
        @list_1 = []
        @list_2 = []
        for location_id_pairs in location_ids do
            pairs = location_id_pairs.split('   ')
            @list_1.push(pairs[0].to_i)
            @list_2.push(pairs[1].to_i)
        end
        @list_1.sort!
        @list_2.sort!
    end

    def calculate_distance
        distance_array = [@list_1, @list_2].transpose.map { |x| x.reduce(:-).abs }
        sum_distances = distance_array.sum
        return sum_distances
    end

    def calculate_simularity_score
        appears_in_list_2 = @list_1.map { |x| @list_2.select { |y| x == y }.count }
        multiplication_array = [@list_1, appears_in_list_2].transpose.map { |x| x.reduce(:*) }
        return multiplication_array.sum
    end
end
