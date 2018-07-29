function m = ema(x,N)
L = length(x);
m = zeros(L,1);
w = 2/(N+1);
m(1) = x(1);
for i=2:L
    m(i) = w*(x(i)-m(i-1)) + m(i-1);
end