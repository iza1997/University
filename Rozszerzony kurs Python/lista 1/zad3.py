def romb(n):
	ht = 1
	puste = n
	tab = []
	for i in range (0, n):
		new = puste*' ' + ht*'#' 
		tab.append(new)
		ht += 2
		puste -=1
	for i in range (0,n) :
		print(tab[i])
	print(ht*'#')
	for i in range(0,n):
		print(tab[n-i-1])

romb(4)
