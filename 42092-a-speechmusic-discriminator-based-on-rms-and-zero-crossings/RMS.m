%Computes the RMS of signal y
function [x] = RMS(y)

x = 0;
for i=1:length(y),
   x = x+y(i)*y(i);
end
x =sqrt(x); 

