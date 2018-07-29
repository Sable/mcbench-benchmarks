function y=jinc(r)
% y=jinc(r) returns the jinc function [J1(2*pi*r)/(2*pi*r)] evaluated
% at r. Per this definition, the first zero of jinc function is at 0.61.

y=real(2*besselj(1,2*pi*r)./ (2*pi*r)); 
%Imaginary parts due to numerical error are of order 1E-16. 

%Division by zero leads to NaN.
y(isnan(y))=1;

end
