%
% E=engset(m,n,rho)
%
% This function computes the Engset blocking probability for a system with
% a finite population m of customers, n servers, no waiting line,
% exponentially distributed service times with parameter mu, and 
% exponentially distributed times between service requests with
% parameter lambda.  The intensity parameter is rho=lambda/mu.  
%
% The probability is 
%
%  E=nchoosek(m,n)*rho^n/sum(nchoosek(m,k)*rho^k,k=0..n)
%
% Note that if m<=n, then the blocking probability is 0.
%
% We use a recurrence relation which is more accurate than direct evaluation 
% of the above formula.  This recurrence relation is a "folk
% theorem".  The author would appreciate a reference to its first
% publication.
%
% The recurrence is
%
% E(m,0,rho)=1;
%
% E(m,n,rho)=(rho*(m-n+1)*E(m,n-1,rho))/(n+rho*(m-n+1)*E(m,n-1,rho)) (n>0)
%
function E=engset(m,n,rho)
%
% Sanity check- make sure that m and n are positive integers.
%
  if ((floor(m) ~= m) || (m < 1))
    warning('m is not a positive integer');
    E=NaN;
    return
  end
  if ((floor(n) ~= n) || (n < 0))
    warning('n is not a nonnegative integer');
    E=NaN;
    return
  end
%
% Sanity check- make sure that rho >= 0.0.
%
  if (rho < 0.0)
    warning('rho is negative!');
    E=NaN;
    return
  end;
%
% Special case.  If we have fewer customers than servers, than the
% blocking probability is 0.
%
  if (m<=n)
    E=0;
    return
  end
%
%
% Start the recursion with B=1.
%
E=1;
%
% Run the recursion.
%
for k=1:n,
  E=(rho*(m-k+1)*E)/(k+rho*(m-k+1)*E);
end;
