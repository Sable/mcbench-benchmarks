function F = make_image(x, y, z)
M = range(x);
N = range(y);
xm = min(x);
ym = min(y);
P = size(x, 1);
F = zeros(M, N);
for p = 1:P
    F(x(p) - xm + 1, y(p) - ym + 1) = z(p);
end