class Jawna

	def initialize(napis)
		@napis = napis
	end

	def to_s
		@napis
	end

	def zaszyfruj(klucz)

		pom = ""
		i = 0
		while i < @napis.length
			pom += (klucz[@napis[i]])
			i += 1
		end

		return Zaszyfrowane.new(pom)

	end
end

class Zaszyfrowane

	def initialize(napis)
		@napis = napis
	end

	def to_s
		@napis
	end

	def odszyfruj(klucz)
    
		pom = ""
    
		i = 0
		while i < @napis.length
			pom += klucz.index(@napis[i])
			i += 1
		end

		return Jawna.new(pom)
	end
end

slowo = Jawna.new("ruby")
puts slowo
klucz = { 'a' => 'b',
'b' => 'r',
'r' => 'y',
'y' => 'u',
'u' => 'a'
}
puts slowo.zaszyfruj(klucz)
zaszyfrowaneslowo = Zaszyfrowane.new("yaru")
puts zaszyfrowaneslowo.odszyfruj(klucz)
