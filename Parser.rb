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

book_authors = []
both_authors = []
long_cds = []
puts "1. The 5 most exspenive items per type are as follows:"
types.each do |type|
  puts "-------#{type}-------"

  # Select the uniq type set of hashes
  uniq_type = data_hash.select{|s| s["type"] == type}

  # Find the top 5 most expensive items for each type
  puts uniq_type.sort_by{|j| -j["price"]}.take(5)
  if type == "book"
    book_authors = uniq_type.collect{|j| j["author"]}.uniq
  elsif type == "cd"
    cd_authors = uniq_type.collect{|j| j["author"]}.uniq
    
    # Combine unique authors of both books and cds to find authors who have done both
    both_authors = cd_authors & book_authors
    uniq_type.each do |cd|
      track_list = cd["tracks"]

      # Count the amount of total seconds in a cd and see if it is greater than an hour in seconds
      if track_list.collect{|t| t["seconds"]}.inject(:+) > 3600
        long_cds << cd["title"].to_s  + " by " + cd["author"].to_s  + " in the year: " + cd["year"].to_s
      end
    end
  end
end
puts "2. CD's that are longer than an hour are as follows:"
puts long_cds
puts "3. The following authors have released both a book and cd:"
puts both_authors