function [A]=comp2real(V)
%these function give vector of 'V' that have complex or non_complex number
%and separate real & imaginary part and attach those in one Matrix.
%this function put together real & imaginary part of any number in any row
m=length(V);
q=[];
for i=1:m
    q(i,1)=real(V(i));
    q(i,2)=imag(V(i));
end
A=q;
    