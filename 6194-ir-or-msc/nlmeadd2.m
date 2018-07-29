function g=nlmeadd2(B,i,b,D)

% An estimate of the Co-variance matrix made by means of an earlier performed Least Squares Estimation.

degradationdata;
timedata;
degradation_function=zeros(1,J);
f=zeros(1,J);
for j=1:J

% The degradation function
degradationfunction
end

if isreal(degradation_function)>=1
    f=degradation_function;
else f=NaN;
end
  
g=(sqrt(sum((abs(Y(i,:)-f)).^2))).^2+transp(b)*inv(D)*b;


