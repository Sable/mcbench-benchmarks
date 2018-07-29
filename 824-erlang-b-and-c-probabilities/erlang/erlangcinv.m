%
% n=erlangcinv(p,rho)
%
% This function finds the smallest n such the Erlang C probability that
% a system with n servers, infinite waiting line, Poisson arrival rate lambda,
% service rate (per server) mu, and intensity rho=lambda/mu will have
% a probability <=p of having all servers busy. 
%
% The Erlang B probability is computed using the same recursion that the 
% erlangb() function uses.  The B probability is then used to compute
% the Erlang C probability.  The Erlang C probability is given by 
%
%  C(n,rho)=n*B(n,rho)/(n-rho*(1-B(n,rho)))
%
% See Cooper, Introduction to Queueing Theory, 2nd Ed.
%
% This routine simply loops through the recursion until C is <= p, and
% then returns n.  
%
function n=erlangcinv(p,rho)
%
% Start the recursion with B=1.
%
B=1;
%
% Loop, iterating the recursion until the probability is <= p.
%
n=1;
while (1 == 1),
  B=((rho*B)/n)/(1+rho*B/n);
  C=n*B/(n-rho*(1-B));
  if (C <= p),
    return;
  end; 
  n=n+1;
end;
