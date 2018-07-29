function T = mytoeplitz(c, r)
% function T = mytoeplitz(c, r)
% Emulate the function TOEPLITZ for fun...

if nargin<2
    r=c;
end

c=c(:);
r=r(:);
v = [flipud(c); r(2:end)];

sz= [length(c) length(r)];
[I J] = itril(sz,Inf);
K = J-I+length(c);
Ilin = sub2ind(sz, I, J);
T = zeros(sz);
T(Ilin) = v(K);