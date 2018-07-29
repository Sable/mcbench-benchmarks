function [xn, yn, zn] = findnearest (x, y, z, x0, y0, N)
d = (x0 - x).^2 + (y0 - y).^2;
[md, i] = min (d);
xn1 = x(i); yn1 = y(i); zn1 = z(i);
xn2 = []; yn2 = []; zn2 = [];
if N > 1
    x = [x(1:i-1); x(i+1:end)];
    y = [y(1:i-1); y(i+1:end)];
    z = [z(1:i-1); z(i+1:end)];
    [xn2, yn2, zn2] = findnearest (x, y, z, x0, y0, N-1);
end
xn = [xn1; xn2];
yn = [yn1; yn2];
zn = [zn1; zn2];