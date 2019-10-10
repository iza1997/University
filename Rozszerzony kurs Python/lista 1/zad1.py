def vat_faktura(lista):
	sum=0
	for i in lista:
		sum+=i
	return sum*0.23
	
def vat_paragon(lista):
	sum=0
	for i in lista:
		sum+=i*0.23
	return sum
	
zakupy = [0.2, 0.5, 6. ,4.59]
print(vat_faktura(zakupy))
print(vat_paragon(zakupy))

print(vat_faktura(zakupy) == vat_paragon(zakupy))
