function z0 = lininter(x, y, z, x0, y0)
[xn, yn, zn] = findnearest(x, y, z, x0, y0, 4);
F = [];
for i = 1:4
    F = [F; xn(i) yn(i) xn(i)*yn(i) 1];
end
A = F\zn;
z0 = A(1)*x0 + A(2)*y0 + A(3)*x0*y0 + A(4);