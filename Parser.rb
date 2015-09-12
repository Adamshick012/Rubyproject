#!/usr/bin/env ruby
require 'rubygems' # 1.8.7

require 'json'

# Method: parser
# Function: gets the user input and parses the JSON or file
# Return: returns a parsed hash
def parser
  user_input = STDIN.gets.chomp
  begin
    if File.exist?(user_input.gsub("\n",''))
      file = File.read(user_input.gsub("\n",''))
      data_hash = JSON.parse(file)
    else
      data_hash = JSON.parse(user_input)
    end
    return data_hash
  rescue JSON::ParserError
    puts "Unable to parse file or manual inputed inventory. Please try again."
    parser
  end
end

puts "Enter Inventory JSON list or JSON file. Press enter then type END and enter."
$/ = "END"  
data_hash = parser

# Finds the different types of items in the inventory
types = data_hash.collect{|j| j["type"]}.uniq.sort_by{|word| word.downcase}

puts "1. The 5 most exspenive items per type are as follows:"
types.each do |type|
  puts "-------#{type}-------"

  # Select the uniq type set of hashes
  uniq_type = data_hash.select{|s| s["type"] == type}

  # Find the top 5 most expensive items for each type
  puts uniq_type.sort_by{|j| -j["price"]}.take(5)
end