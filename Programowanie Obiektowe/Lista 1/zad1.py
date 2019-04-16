class Wezel:
    def __init__(self,value):
        self.val = value
        self.left = None
        self.right = None


def wstaw(root,nkey):
            if (root==None): return Wezel(nkey)
            if (nkey < root.val):
                root.left = wstaw(root.left,nkey)
            else:
                if (nkey > root.val):
                    root.right = wstaw(root.right, nkey)
            return root
        
def szukaj( root, skey):
    if (root==None):
        return False
    if (root.val == skey):
        return True
    if (root.val > skey):
        return szukaj(root.left, skey)
    else:
        return szukaj(root.right, skey)

        
def drzewko(lista):
        root=None
        for i in range(len(lista)):
                root = wstaw(root,lista[i])
        return root

        
def rozmiar(drzewo):
    if drzewo==None: return 0
    return 1+rozmiar(drzewo.left)+rozmiar(drzewo.right)




 
