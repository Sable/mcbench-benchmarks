%Small test problem, optimal solution should be -21
c = -[8 11 6 4]
A = [5 7 4 3]
b = 14
Aeq = []
beq = []
lb = [0 0 0 0]'
ub = [1 1 1 1]'
yidx = true(4,1)
miprog(c,A,b,Aeq,beq,lb,ub,yidx)