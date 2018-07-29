function X=decode(temp,L,x_max)
x=0;
for i=1:L
    x=x+temp(i)*2^(i-1);
end
x=x/(2^L-1);
X=((2*x_max)/(1-0))*(x-0)-x_max;
return