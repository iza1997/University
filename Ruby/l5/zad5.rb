# -*- encoding : utf-8 -*-
require "open-uri"
class Searcher
	def initialize
	  @statistics = Hash.new
	end
  
	def look_on_site(page)
	  File.read(page).each_line do |line|
		words = line.split(" ")
		words.each do |word|
		  @statistics.key?(word) ? @statistics[word] += [page] : @statistics[word] = [page]
		end
	  end
	end
  
	def index(start_page, depth)
	  Dir.foreach(start_page) do |file|
		if File.directory?(start_page + "/" + file) and file.start_with?('.') then next end
		if File.directory?(start_page + "/" + file)
		  if depth > 0 then self.index(start_page + "/" + file, depth-1) end
		else
	  look_on_site(start_page + "/" + file)
		end
	  end
	end
  
	def search(reg_exp)
	  @statistics.each do |word, sites|
		if word.scan(reg_exp).any? then p word + ": " +  @statistics[word].to_s end
	  end
	end
  end
  
  
  searcher = Searcher.new
  searcher.index("https://www.google.com/", 1)
  puts searcher.search(/<h.+>/m)
