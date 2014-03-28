require_relative 'assign_shelves'

puts "Lets stock those shelves!  Enter the file path to you shelf data."
shelf_path = gets.chomp

while !File.exist?(shelf_path)
  puts "Could not find file, please enter a correct path to your shelf data."
  shelf_path = gets.chomp
end

puts "Awesome, now enter the path to your Product Data"
product_path = gets.chomp

while !File.exist?(product_path)
  puts "Could not find file, please enter a correct path to your product data."
  product_path = gets.chomp
end

puts ""
puts "For optimal revenue stock your products like so:"
puts ""
stock = AssignShelves.new(shelf_path, product_path)
stock.sort_products
stock.sort_shelves
stock.output_instructions