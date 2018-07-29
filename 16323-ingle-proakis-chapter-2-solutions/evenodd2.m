function [xe, xo, m] = evenodd2(x,n) % Real and imaginary signal decomposition into even and odd parts 
% ------------------------------------------------- 
% [xe, xo, m] = evenodd2(x,n) % 
if any(imag(x) ~= 0) 
    m = -fliplr(n); 
    m1 = min([m,n]); 
    m2 = max([m,n]); 
    m = m1:m2; nm = n(1)-m(1); 
    n1 = 1:length(n); 
    x1 = zeros(1,length(m)); 
    x1(n1+nm) = x; 
    x = x1; 
    xe = 0.5*(x + conj(fliplr(x))); 
    xo = 0.5*(x - conj(fliplr(x))); 
else 
    m = -fliplr(n); 
    m1 = min([m,n]); 
    m2 = max([m,n]); 
    m = m1:m2; 
    nm = n(1)-m(1); 
    n1 = 1:length(n); 
    x1 = zeros(1,length(m)); 
    x1(n1+nm) = x; x = x1; 
    xe = 0.5*(x + fliplr(x)); 
    xo = 0.5*(x - fliplr(x)); 
end