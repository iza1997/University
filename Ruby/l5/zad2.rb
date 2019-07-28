require "open-uri"
require "open_uri_redirections"

def slowa(page)
	body = false
	slownik= {}
	open(page, :allow_redirections => :all) { |i|
		i.each_line { |line|
		if /<body.?/.match(line)
			body = true
		end
		if /<\/body>/.match(line)
			body = false
		end
		if body
			tmp = line.split(/<.+?>|<\/.+?>| /)
			tmp.delete("")
			tmp.delete("\n")
			tmp.each do |s| 
				s = s.delete("\n")
				s = s.downcase
				if slownik[s] == nil
					slownik[s] = 1
				else
					slownik[s] = slownik[s] + 1
				end
			end
		end
	}
}
return slownik
end

$slownik1 = {}
def przeglad(page, depth, block)
	$slownik1[page] = block.call(page)
	if depth>0 
		begin
		open(page, :allow_redirections => :all) { |i|
			i.each_line { |line|
				tmp = /href="/.match(line)
				tmp1 = /<link rel="/.match(line)
				if tmp and (not tmp1)
					tmp = /href=".{1,}"/.match(line)
					tmp1 = $&
					/href="/.match(tmp1)
					tmp = $'.delete '"'
					if not /http/.match(tmp)
						tmp = page + tmp.to_s
					end
					przeglad(tmp, depth-1, block)
				end

			}
		}
		rescue			
		end
	end
end

def index(page, depth)
	puts przeglad(page,depth,lambda {|i| return slowa(i)})
end

index("https://www.ii.uni.wroc.pl/~marcinm/", 1)

def search(reg_exp)
	tab = []
	$slownik1.keys.each do |i| 
		$slownik1[i].each do |s, m|
			if reg_exp.match(s)
				tab.push(i)
			end
		end
	end
	return tab.uniq
end

puts search(/termin/)
