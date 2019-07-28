require "open-uri"
require "open_uri_redirections"


def page_weight(page)
	res = 0
	begin
		open(page, :allow_redirections => :all) { |i|
			i.each_line { |line|
				if /<img/.match(line)
					res+=1
				elsif /<applet/.match(line)
					res +=1
				end
			}
		}
	return res
	rescue
		return "Błąd strony"
	end
end


def page_summary(page)
	head = false
	new_line = false
	a = ""
	title = false
	tmp = ""
	result = ""
	begin
	open(page, :allow_redirections => :all) { |i|
		i.each_line { |line|
			if /<\/head>/.match(line)
				head = false
				break
			end
			if /<head>/.match(line) 
				head = true
			end
			if title
				if /<\/title>/.match(line)
					result = result + "title: " + tmp + "\n"
				else
					tmp = tmp + line
				end
			end
			if /<title>/.match(line)
				title = true
				b = $'
				if /<\/title>/.match(b)
					title = false
					result = result + "title : " + $` + "\n"
				end
			end
			if head and new_line
				/content=/.match(line)
				b = $'
				/>/.match(b)
				new_line = false
				result = result + a + ":" + $` + "\n"
			end
			if head and /<meta name=/.match(line) 
				a = $'.delete "\n"
				if (/content=/.match(a))
					a = $`
					b = $'
					/>/.match(b)
					result = result + a + ": " + $` + "\n"
				else
					new_line = true
				end
			end
		}
	}
	return result
rescue
	return "Niebezpieczna"
end
end



def przeglad(page, depth, block)
	block.call(page)
	if depth>0 
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
	end
end
puts przeglad("https://www.ii.uni.wroc.pl/~marcinm/", 1, lambda {|x| puts "#{x} WEIGHT: #{page_weight(x)}\n#{x} SUMMARY:\n#{page_summary(x)}\n"}) 
