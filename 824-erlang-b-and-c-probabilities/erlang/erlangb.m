%
% B=erlangb(n,rho)
%
% This function computes the Erlang B probability that a system with n
% servers, no waiting line, Poisson arrival rate lambda, service rate 
% (per server) mu, and intensity rho=lambda/mu will have all servers busy.  
%
% The probability is 
%
%  B=(rho^m/m!)/(sum(rho^k/k!),k=0..m)
%
% It uses a recurrence relation which is more accurate than direct evaluation 
% of the formula.  This recurrence relation is a "folk theorem".  The author
% would appreciate a reference to its first publication.  The recurrence is
%
%  B(0,rho)=1
%
%  B(n,rho)=(rho*B(n-1,rho)/n)/(1+rho*B(n-1,rho)/n)
%
%
function B=erlangb(n,rho)
%
% Sanity check- make sure that n is a positive integer.
%
  if ((floor(n) ~= n) || (n < 1))
    warning('n is not a positive integer');
    B=NaN;
    return;
  end;
%
% Sanity check- make sure that rho >= 0.0.
%
  if (rho < 0.0)
    warning('rho is negative!');
    B=NaN;
    return;
  end;
%
% Start the recursion with B=1.
%
B=1;
%
% Run the recursion.
%
for k=1:n,
  B=((rho*B)/k)/(1+rho*B/k); 
end;
