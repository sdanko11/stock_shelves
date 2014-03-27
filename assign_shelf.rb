require 'pry'
require 'json'

class AssignShelves

  def initialize
    @products = JSON.parse(File.read("products.json"))["products"]
    @shelves = JSON.parse(File.read("shelves.json"))["shelves"]
  end

  def sort_products
    @products.sort_by! { |product| product["value"] }.reverse!
  end

  def sort_shelfs
    @shelves.sort_by! {|product| product["visibility"] }.reverse!
  end

  def output_instructions
    until @shelves.count == 0 || @products.count == 0
      if (shelf_capacity - (size_of_product * @products.first["qty"])) == 0
        puts "Stock the #{@shelves.first["row"]} shelf with #{@products.first["qty"]} #{@products.first["name"]}(s)."
        @products.delete(@products.first)
        @shelves.delete(@shelves.first)
      elsif (shelf_capacity - (size_of_product * @products.first["qty"])) > 0
        puts "Stock the #{@shelves.first["row"]} shelf with #{@products.first["qty"]} #{@products.first["name"]}(s)."
        @shelves.first["capacity"] -= (size_of_product * @products.first["qty"])
        @products.delete(@products.first)
      elsif (shelf_capacity - (size_of_product * @products.first["qty"])) < 0
        puts "Stock the #{@shelves.first["row"]} shelf with " + number_of_products + " #{@products.first["name"]}(s)."
        @products.first["qty"] = product_left_over
        @shelves.delete(@shelves.first)
      end
    end
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

end

stock = AssignShelves.new
stock.sort_products
stock.sort_shelfs
stock.output_instructions