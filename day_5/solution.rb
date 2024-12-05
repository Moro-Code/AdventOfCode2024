require_relative "helpers"

updates = Updates.new("./updates.txt")

orders = Orders.new("./orders.txt")


valid_updates = updates.get_valid_updates(orders)

sum = 0 

for update in valid_updates
    sum += update[(update.length - 1)/2]
end

puts sum

invalid_updates = updates.get_updates - valid_updates
fixed_updates = []
for update in invalid_updates
    fixed_updates.push(orders.fix_update(update))
end

fixed_updates_sum = 0 
for update in fixed_updates
    fixed_updates_sum += update[(update.length - 1)/2]
end

puts fixed_updates_sum