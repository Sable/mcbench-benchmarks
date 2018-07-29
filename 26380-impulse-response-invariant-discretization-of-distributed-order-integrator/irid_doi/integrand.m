function y=integrand(a,b,t,x)
i=sqrt(-1);
y = (exp(-x.*t).*(x.^(b-a).*exp(-i*(b-a)*pi)-1)./((x.^b).*exp(-i*b*pi).*(log(x)-i*pi))-exp(-x.*t).*(x.^(b-a).*exp(i*(b-a)*pi)-1)./((x.^b).*exp(i*b*pi).*(log(x)+i*pi)))/(2*pi*i);
