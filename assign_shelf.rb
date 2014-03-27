require 'pry'
require 'json'

class AssignShelves

  attr_accessor :products, :shelves

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

  def stock_shelfs
    until @shelves.count == 0 || @products.count == 0
      if (@shelves.first["capacity"] - (@products.first["size"] * @products.first["qty"])) == 0
        puts "Stock the #{@shelves.first["row"]} shelve with #{@products.first["qty"]}, #{@products.first["name"]}(s)."
        @products.delete(@products.first)
        @sheves.delete(@shelves.first)
      elsif (@shelves.first["capacity"] - (@products.first["size"] * @products.first["qty"])) > 0
        puts "Stock the #{@shelves.first["row"]} shelve with #{@products.first["qty"]}, #{@products.first["name"]}(s)."
        @shelves.first["capacity"] -= (@products.first["size"] * @products.first["qty"])
        @products.delete(@products.first)
      elsif (@shelves.first["capacity"] - (@products.first["size"] * @products.first["qty"])) < 0
        puts "Stock the #{@shelves.first["row"]} shelve with #{(@shelves.first["capacity"]/@products.first["size"])}, #{@products.first["name"]}(s)."
        @products.first["qty"] = (((@shelves.first["capacity"] - (@products.first["size"] * @products.first["qty"])) * -1).to_f/@products.first["size"].to_f).ceil
        @shelves.delete(@shelves.first)
      end
    end
  end

end

stock = AssignShelves.new
stock.sort_products
stock.sort_shelfs
stock.stock_shelfs