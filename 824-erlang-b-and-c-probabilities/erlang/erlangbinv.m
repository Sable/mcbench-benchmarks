%
% n=erlangbinv(p,rho)
%
% This function finds the smallest n such the Erlang B probability that
% a system with n servers, no waiting line, Poisson arrival rate lambda,
% service rate (per server) mu, and intensity rho=lambda/mu will have
% a probability <=p of having all servers busy. 
%
% The Erlang B probability is given by 
%
%  B=(rho^m/m!)/(sum(rho^k/k!),k=0..m)
%
% We use a recurrence relation which is more accurate than direct evaluation 
% of the formula.  This recurrence relation is a "folk theorem".  The author
% would appreciate a reference to its first publication.  The recurrence is
%
%  B(0,rho)=1
%
%  B(n,rho)=(rho*B(n-1,rho)/n)/(1+rho*B(n-1,rho)/n)
%
% This routine simply loops through the recursion until B is <= p, and
% then returns n.  
%
function n=erlangbinv(p,rho)
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
  if (B <= p),
    return;
  end; 
  n=n+1;
end;
