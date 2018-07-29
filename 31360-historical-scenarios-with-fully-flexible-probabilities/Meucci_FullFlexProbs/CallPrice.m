function C=CallPrice(P, K, r, t, s)

d_1=log(P/K)+(r+s.*s/2)*t;
d_2=d_1-s*sqrt(t);

C=P.*normcdf(d_1)-K*exp(-r*t).*normcdf(d_2);