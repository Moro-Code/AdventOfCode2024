class Orders
    def initialize(file_path)
        @orders = File.open(file_path).readlines.map(&:chomp)
        @order_dict = {}
        for order in @orders
            order_array = order.split("|")
            page_number = order_array[0].to_i
            must_be_before = order_array[1].to_i
            if @order_dict[page_number].nil?
                @order_dict[page_number] = [must_be_before]
            else
                @order_dict[page_number].push(must_be_before)
            end
        end
    end

    def get_order_dict
        @order_dict
    end

    def validate_update(update, page_number, index)
        if @order_dict[page_number].nil?
            return true
        end
        
        items_before_page_number = update[0..index]

        diff = items_before_page_number - @order_dict[page_number]
        # there should not be any items in the before page number list that are in the order list 
        return diff.length == items_before_page_number.length, items_before_page_number - diff
    end

    def fix_update(update)
        current_index = update.length - 1
        while current_index >=0
            page_number = update[current_index]
            valid, diff = validate_update(update, page_number, current_index)
            if !valid
                index_to_switch = update.find_index(diff[0])
                update[current_index] = diff[0]
                update[index_to_switch] = page_number
            else
                current_index -= 1
            end
        end
        return update
    end 
end


class Updates
    def initialize(file_path)
        @updates = File.open(file_path).readlines.map(&:chomp).map {|update| update.split(",")}.map { |update| update.map(&:to_i) }
    end

    def get_updates
        @updates
    end

    def get_valid_updates(orders)
        valid_updates = []
        for update in @updates
            update_is_valid = true 
            update.each_with_index { |page_number, index|
                valid, diff = orders.validate_update(update, page_number, index)
                if !valid
                    update_is_valid = false
                end
            }

            if update_is_valid
                valid_updates.push(update)
            end
        end

        return valid_updates
    end
end