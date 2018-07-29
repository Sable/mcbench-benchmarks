function g = TestModel(x,p)

g = prod((abs(4*x - 2) + p)./(1 + p));