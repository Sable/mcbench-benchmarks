function z0 = bicinter(x, y, z, x0, y0)
N = 16;
M = 4;
[xn, yn, zn] = findnearest(x, y, z, x0, y0, N);
F = zeros(N, N);
for p = 1:N
    Fr = zeros(1, N);
    for i = 1:M
    for j = 1:M
        Fr( map_ijk(i, j, M) ) = (xn(p)^(i-1))*(yn(p)^(j-1));
    end
    end
    F(p, :) = Fr;
end
a = F\zn;
z0 = 0;
for i = 1:M
for j = 1:M
    z0 = z0 + a( map_ijk(i, j, M) )*(x0^(i-1))*(y0^(j-1));
end
end

function k = map_ijk (i, j, M)
    k = (i-1)*M + j;