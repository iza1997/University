def reszta(kwota):
	nominaly = [10, 5, 2, 1]
	wynik = 0
	banknoty =[]
	max=20
	i=0
	while (kwota >0):
		while((kwota-max) <0):
			max=nominaly[i]
			i+=1
		kwota-=max
		banknoty.append(max)
		wynik+=1
	print("liczba monet i banknotów: " + str(wynik))
	print(banknoty)
	
reszta(123)
