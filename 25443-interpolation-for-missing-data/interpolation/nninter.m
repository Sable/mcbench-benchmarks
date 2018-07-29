function z0 = nninter(x, y, z, x0, y0)
[xn, yn, zn] = findnearest(x, y, z, x0, y0, 1);
z0 = zn;