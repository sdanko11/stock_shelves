require 'json'

class AssignShelves

  def initialize(shelf_data, product_data)
    @products = JSON.parse(File.read(product_data))["products"]
    @shelves = JSON.parse(File.read(shelf_data))["shelves"]
    @extra_space = {}
  end

  def sort_products
    @products.sort_by! { |product| product["value"] }.reverse!
  end

  def sort_shelves
    @shelves.sort_by! {|product| product["visibility"] }.reverse!
  end

  def output_instructions
    until @shelves.count == 0 || @products.count == 0
      if !@extra_space.empty?
        stock_extra_space
      elsif (shelf_capacity - (size_of_product * @products.first["qty"])) == 0
        puts "Stock the #{@shelves.first["row"]} shelf with #{@products.first["qty"]} #{@products.first["name"]}(s)."
        @products.delete_at(0)
        @shelves.delete_at(0)
      elsif (shelf_capacity - (size_of_product * @products.first["qty"])) > 0
        puts "Stock the #{@shelves.first["row"]} shelf with #{@products.first["qty"]} #{@products.first["name"]}(s)." if @products.first["qty"] > 0
        @shelves.first["capacity"] -= (size_of_product * @products.first["qty"])
        @products.delete_at(0)
      elsif (shelf_capacity - (size_of_product * @products.first["qty"])) < 0
        puts "Stock the #{@shelves.first["row"]} shelf with " + number_of_products + " #{@products.first["name"]}(s)." if number_of_products.to_i > 0
        @products.first["qty"] = product_left_over
        @shelves.first["capacity"] -= (number_of_products.to_i * size_of_product)
        check_for_space
      end
    end
  end

  def stock_extra_space
    is_there_room_for_product = true
    while is_there_room_for_product
      @products.each do |product|
        if product["size"] <= @extra_space.values.join.to_i
          count_product = 0
          until product["size"] > @extra_space.values.join.to_i
            count_product += 1
            space_left = (@extra_space.values.join.to_i - product["size"])
            @extra_space = { @extra_space.keys.join => space_left }
          end
          puts "Stock the #{@extra_space.first[0]} shelf with " + count_product.to_s + " #{product["name"]}(s)."
          product["qty"] -= count_product
          count_product = 0
        end
      end
      is_there_room_for_product = false
    end
    @extra_space.clear
  end

  def number_of_products
    (@shelves.first["capacity"]/size_of_product).to_s
  end

  def shelf_capacity
    @shelves.first["capacity"]
  end

  def size_of_product
    @products.first["size"]
  end

  def product_left_over
    (((@shelves.first["capacity"] - (size_of_product * @products.first["qty"])) * -1).to_f/size_of_product.to_f).ceil
  end

  def check_for_space 
    if @shelves.first["capacity"] > 0
      @extra_space = {@shelves.first["row"] => @shelves.first["capacity"]}
    end
    @shelves.delete_at(0)
  end

end