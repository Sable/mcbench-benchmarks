% sub module for diffusion step in simpltrans
for i = 2:N-1
    c2(i) = c1(i) + Neumann*(c1(i-1)-2*c1(i)+c1(i+1)); 
end
c2(1) = c1(1) + Neumann*(cin-2*c1(1)+c1(2));
c2(N) = c1(N) + Neumann*(c1(N-1)-c1(N)); 
c1 = c2;