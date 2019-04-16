def add(a,b):
    return (a[0] + b[0], a[1] + b[1])

def sub(a,b):
    return (a[0] - b[0], a[1] - b[1])

def mult(a,b):
    return (a[0] * b[0] - a[1] * b[1], a[1] * b[0] + a[0] * b[1])

def div(a,b):
    sprz = (b[0], - b[1])
    g = (a[0] * sprz[0] - a[1] * sprz[1], a[1] * sprz[0] + a[0] * sprz[1])
    d = (b[0] * sprz[0] - b[1] * sprz[1],b[1] * sprz[0] + b[0] * sprz[1])
    rzeczywista = d[0]
    return (g[0] / rzeczywista, g[1] / rzeczywista)

def add2(a,b):
    return b

def sub2(a,b):
    return b

def mult2(a,b):
    return b

def div2(a,b):
    sprz = (b[0], - b[1])
    g = (a[0] * sprz[0] - a[1] * sprz[1], a[1] * sprz[0] + a[0] * sprz[1])
    d = (b[0] * sprz[0] - b[1] * sprz[1],b[1] * sprz[0] + b[0] * sprz[1])
    rzeczywista = d[0]
    b = (g[0] / rzeczywista, d[1] / rzeczywista)
    return b
