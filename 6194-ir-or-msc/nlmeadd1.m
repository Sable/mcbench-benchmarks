
function g=nlmeadd1(b,B,Y,D)

timedata;
degradation_function=zeros(1,J);
f=zeros(1,J);

for j=1:J
    
% The degradation function
degradationfunction


if isreal(degradation_function)>=1
    f=degradation_function;
else f=NaN;
end

g=(sqrt(sum((abs(Y-f)).^2))).^2+transp(b)*inv(D)*b;

end
