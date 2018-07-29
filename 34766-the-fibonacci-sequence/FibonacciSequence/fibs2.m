function [Fn,Ln] = fibs2(n)
% fibs2: vpi tool to efficiently compute the n'th Fibonacci number and the n'th Lucas number
% usage: [Fn,Ln] = fibs2(n)
%
% the "2*n" identities are employed here:
%  F(2*m) = F(m)*L(m)
%  L(2*m) = (5*F(m)^2 + L(m)^2)/2
%
% coupled with the addition identities
%
%  F(m+1) = (F(m) + L(m))/2
%  L(m+1) = (5*F(m) + L(m))/2


if (nargin~=1) || (numel(n) ~= 1) || (n~=round(n)) || (abs(n) > 2^53)
  error('n must be scalar and an integer, <= 2^53 in absolute value')
end

% much faster if n is not a vpi but a double.
% also, we don't need to worry about n being
% larger than 2^53, as this would have a vast
% number of digits.
n = double(n);

% ensure that n is positive, handle the negative
% cases too here.
if n < 0
  n = abs(n);
  [Fn,Ln] = fibs2(n);
  if iseven(n)
    Fn = -Fn;
  else
    Ln = -Ln;
  end
  return
end

% a few special cases to end the recursion,
% depending where we came in.
if n <= 3
  switch n
    case 2
      Fn = vpi(1);
      Ln = vpi(3);
    case 3
      Fn = vpi(2);
      Ln = vpi(4);
    case 1
      Fn = vpi(1);
      Ln = vpi(1);
    case 0
      Fn = vpi(0);
      Ln = vpi(2);
  end
  return
end
% n is now known to be at least 4.
%
% Next, we will use several identities relating
% F(2*n) and L(2*n) to F(n) and L(n), and between
% the Fibonacci and Lucas numbers.

% Is n a multiple of 2?
if iseven(n)
  % even, so use 
  [Fnover2,Lnover2] = fibs2(n./2);
  
  % Use the double argument formulas
  Fn = Fnover2.*Lnover2;
  Ln = (5 .*Fnover2.*Fnover2 + Lnover2.*Lnover2)./2;
  
else
  % n must be odd. So if we subtract 1, then
  % n-1 will be even. I could have added 1
  % instead, but I want to make n as small
  % as possible, as quickly as I can.
  [Fnover2,Lnover2] = fibs2((n-1)./2);
  
  % Use the double argument identities
  Fnminus1 = Fnover2.*Lnover2;
  Lnminus1 = (5 .*Fnover2.*Fnover2 + Lnover2.*Lnover2)./2;
  
  % this has only gotten us to F(n-1) and
  % L(n-1). use the addition identities to
  % move up one more step.
  Fn = (Lnminus1 + Fnminus1)./2;
  Ln = (5 .*Fnminus1 + Lnminus1)./2;
end
  
function result = iseven(n)
% tests if a scalar value is an even integer
if isnumeric(n)
  result = (mod(n,2) == 0);
elseif isa(n,'vpi')
  % must have been a vpi
  result = (mod(trailingdigit(n,1),2) == 0);
else
  error('n must be either numeric or vpi')
end


