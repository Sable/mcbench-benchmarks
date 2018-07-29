% This function calculates the fractional derivative of order d for the 
% given function r(t). It is assumed that the vector r contains the 
% samples of the continuous signal r(t) which we are going to calculate its
% fractional derivative. h is a constant and represents the sampling
% period of r(t) (the time period between two samples). h must be small 
% enough in the sense of Nyquist sampling theorem.
% y is the result achieved by applying the fractional differentiation 
% operator on the input r. This contains the samples of the real output
% y(t) with the same sampling period used for r.   
% It makes use of the Grünwald-Letnikov definition. The first element of
% the vector "r", i.e. r(1), is always zero.
% 
% d        :        the order of fractional differentiation 
% r        :        samples of the signal to be differentiated 
% h        :        sampling poriod 


function [y] = fderiv(d,r,h)

temp = 0;
for i=1:length(r)
    for j=0:i-1
        temp = temp+(-1)^j*(gamma(d+1)/(gamma(j+1)*gamma(d-j+1)))*r(i-j);
    end
    y(i) = temp;
    temp = 0;
end
y = y/(h^d);
