function pdsum = aliquotsum(N,p)
% aliquotsum: the sum of all of the proper divisors of N (aliquot sum)
% usage: pdsum = aliquotsum(N)
% usage: pdsum = aliquotsum(N,p)
%
% A proper divisor (of a positive integer N) is a number less than
% N that divides N with a zero remainder and a positive integer
% quotient. It is sometimes known as an aliquot part. The sum of
% the proper divsors is also known as the aliquot sum.
%
%  http://en.wikipedia.org/wiki/Divisor_function
%  http://en.wikipedia.org/wiki/Aliquot
%  http://en.wikipedia.org/wiki/Abundant_number
%  http://en.wikipedia.org/wiki/Deficient_number
%
% Note that a perfect number will have its sum of proper divisors
% equal to the number itself. Those numbers for which the sum
% of their divisors exceeds the number itself are known as abundant
% numbers. Similarly, deficient numbers are those which exceed
% their aliquot sums.
%
% aliquotsum can also form the sum of various powers of the divisors.
% Normally, one would just look for the sum of the first powers, so
% just the sum of the divisors. But the sum of the zero'th powers
% yields the actual number of divisors. And sometimes you might want
% to generate the sum of the squares of the divisors.
%
% arguments: (input)
%  N     - positive integer or any list of such integers
%          N cannot exceed 2^32.
%
%  p     - (OPTIONAL) - scalar power of the divisors used in the sum.
%          p must be a non-negative integer.
%
%          DEFAULT: p = 1
%
%
% arguments: (Output)
%  pdsum - an array the same size and shape as N, contains
%          the sums of proper divisors of each element of N.
%
%
% Example:
%   aliquotsum([2 3 4 6 8 10 12 105 8128])
%   ans =
%       1   1   3   6   7   8   16   87  8128
%
%
% See also: aliquotparts, amicablecycles, factor, primes
% 
%
% Author: John D'Errico
% e-mail: woodchips@rochester.rr.com
% Release: 1.0
% Release date: 9/21/08

% test that N is a positive integer.
if (nargin>2) || (nargin==0)
  error('You must provide N, but no more than 2 arguments')
end

% default for p
if (nargin<2) || isempty(p)
  p = 1;
elseif (length(p)~=1) || (p<0) || (p~=round(p))
  error('p must be a scalar non-negative integer')
end

% in case
sizeN = size(N);
list = N(:);
nN = length(list);
if any(list<0) || any(list~=floor(list)) || any(list>=(2^32))
  error('N must be a positive scalar integer <= 2^32, or a list thereof')
end

% special case a short list
if (nN == 1)
  % Scalar arguments can be processed a wee bit
  % more quickly with a direct call to factor
  f = factor(N);
  [uf,i,j] = unique(f); % Don't use i
  count = accumarray([ones(length(j),1),j'],1);
  pdsum = 1;
  for i = 1:length(uf)
    switch p
      case 1
        pdsum = pdsum*sum(uf(i).^(0:count(i)));
      case 0
        pdsum = pdsum*(1+count(i));
      otherwise
        pdsum = pdsum*sum(uf(i).^(p*(0:count(i))));
    end
  end
  % the sum contains N, but we only want the sum
  % of proper divisors.
  pdsum = pdsum - N.^p;
elseif nN > 1
  % list of all the primes less than sqrt(N)
  maxN = max(list);
  plist = primes(floor(sqrt(maxN)));

  % initialize the sum of all the proper divisors of
  % each element in the list. Since 1 must be a proper
  % divisor of all such numbers, start there.
  sumofdivisors = ones(size(list));
  sumofdivisors(list==0) = 0;

  % Loop over the primes in plist. We will do this using
  % a Euclidean sieve variant, building the sum of divisors
  % as we do the sieve.
  for plisti = plist
    % find all the elements of list that are divisible by
    % plist(i), and which are at least as large as plist(i).
    T = ones(size(list));
    R = rem(list,plisti);
    k = find((R==0) & (list>plisti));
    pow = 1;

    % T(k) will be a geometric sum of powers of
    % the prime factors of each number.
    T(k) = T(k) + plisti.^p;

    % and reduce the corresponding elements of list
    list(k) = list(k)/plisti;

    % is plist(i) a repeated factor?
    while ~isempty(k)
      pow = pow + 1;
      Rk = rem(list(k),plisti);
      kk = find((Rk==0) & (list(k)>=plisti));

      if isempty(kk)
        k = [];
      else
        % update the geometric sum in T
        T(k(kk)) = T(k(kk)) + plisti^(p*pow);

        % and reduce the corresponding elements of list
        list(k(kk)) = list(k(kk))/plisti;
        k = k(kk);
      end
    end

    % The sum of all divisors is the product of T
    % as formed for each independent prime factor
    sumofdivisors = sumofdivisors.*T;

  end

  % The piece that remains in list will also be a
  % proper divisor if it is not equal to 1. If so,
  % this will always be a prime number that we have
  % not checked so far using the seive.
  k = find(list>1);
  if ~isempty(k)
    sumofdivisors(k) = sumofdivisors(k).*(1+list(k).^p);
  end

  % At this point sumofdivisors includes the
  % number itself, so drop it off.
  pdsum = reshape(sumofdivisors,sizeN) - N.^p;
  
else
  % N must have been empty
  pdsum = [];
end % if nN == 1


