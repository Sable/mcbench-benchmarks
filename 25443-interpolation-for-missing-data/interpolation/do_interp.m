xgood = x(z >= 0);
ygood = y(z >= 0);
zgood = z(z >= 0);
xbad = x(z < 0);
ybad = y(z < 0);
P = size(xbad, 1);
zbad = zeros(P, 1);
for p = 1:P
    zbad(p) = bicinter(xgood, ygood, zgood, xbad(p), ybad(p));
    fprintf('%d/%d: %f %f %f\n', p, P, xbad(p), ybad(p), zbad(p));
end
plot3(xgood, ygood, zgood, 'b.', xbad, ybad, zbad, 'r.');