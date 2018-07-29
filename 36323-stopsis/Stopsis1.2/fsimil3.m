function [Simil3]=fuzzysimil3(A,B)

PA=(A(1)+2*A(2)+2*A(3)+A(4))/6;
PB=(B(1)+2*B(2)+2*B(3)+B(4))/6;
dAB=abs(PA-PB);
Simil3=1/(1+dAB);

