function Fn = fibs(n)
% fibs: vpi tool to efficiently compute the n'th and (n-1)'th Fibonacci numbers
% usage: Fn = fibs(n)
%
% A pair of identities are used to cut n by a
% factor of 2 on each iteration through. This
% makes the call to fibs and O(log2(n)) operation
% in time.
% 
%  F(2*m-1) = F(m)^2 + F(m-1)^2
%  F(2*m) = F(m)^2 + 2*F(m-1)*F(m)

if (nargin~=1) || (numel(n) ~= 1) || (n <= 0) || (n~=round(n))
  error('n must be scalar and a positive integer, <= 2^53')
elseif isa(n,'vpi')
  % much faster if n is not a vpi but a double.
  % also, we don't need to worry about n being
  % larger than 2^53
  n = double(n);
end

% a few special cases to end the recursion,
% depending where we came in.
if n <= 3
  if n == 1
    Fn = vpi([0 1]);
  elseif n == 2
    Fn = vpi([1 1]);
  else
    % n must be 3
    Fn = vpi([1 2]);
  end
elseif iseven(n)
  % N is at least 4, and even
  
  % get fibs(n/2)
  Fnover2 = fibs1(n/2);
    
  % combine these results using F(2n), the
  % 2n Fibonacci relations:
  % F(2*m-1) = F(m)^2 + F(m-1)^2
  % F(2*m) = F(m)^2 + 2*F(m-1)*F(m)
  Fn = Fnover2.*Fnover2;
  Fn(1) = Fn(1) + Fn(2);
  Fn(2) = Fn(2) + 2.*Fnover2(1)*Fnover2(2);
    
else
  % N is at least 5 and odd
  
  Fnover2 = fibs1((n-1)/2);
  
  % shift up, using the F(2n) relations
  Fn = Fnover2.*Fnover2;
  Fn(1) = Fn(1) + Fn(2);
  Fn(2) = Fn(2) + 2.*Fnover2(1)*Fnover2(2);
  
  % and shift up just one step
  Fn = [Fn(2), sum(Fn)];
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
