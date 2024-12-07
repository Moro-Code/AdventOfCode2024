require_relative "./helpers"

start_time = Time.now

map = Map.new("./input.txt")

cycles = 0

for row in 0 .. map.height - 1
    for column in 0 .. map.width - 1
        new_map = Map.new("./input.txt")
        obsticle_placed = new_map.place_obsticle([row, column])
        if obsticle_placed
            gaurd = Gaurd.new(new_map)
            while !gaurd.out_of_bounds && !gaurd.cycle_detected
                gaurd.move(new_map)
            end
            if gaurd.cycle_detected
                cycles += 1
            end
        end
    end
end

print cycles

end_time = Time.now
duration = end_time - start_time
puts "Script took #{duration} seconds to execute."