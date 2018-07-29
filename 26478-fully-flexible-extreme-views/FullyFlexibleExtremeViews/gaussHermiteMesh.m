function [x] = gaussHermiteMesh(J)

p = hermitePolynomial(J);
x = roots(p(end, :));
x = real(x);
    
end
