#!/usr/bin/env ruby
require 'rubygems' # 1.8.7

require 'json'

puts "Enter Inventory JSON list or JSON file. Press enter then type END and enter."
$/ = "END"  
user_input = STDIN.gets.chomp
if File.exist?(user_input.gsub("\n",''))
  file = File.read(user_input.gsub("\n",''))
  data_hash = JSON.parse(file)
else
  data_hash = JSON.parse(user_input)
end

# Finds the different types of items in the inventory
types = data_hash.collect{|j| j["type"]}.uniq.sort_by{|word| word.downcase}

types.each do |type|
  puts type

  # Select the uniq type set of hashes
  uniq_type = data_hash.select{|s| s["type"] == type}

  # Find the top 5 most expensive items for each type
  puts uniq_type.sort_by{|j| -j["price"]}.take(5)
end