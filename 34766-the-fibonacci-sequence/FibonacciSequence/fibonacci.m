function [Fn,Ln] = fibonacci(n,modulus)
% fibonacci: vpi tool to efficiently compute the n'th Fibonacci number and the n'th Lucas number
% usage: [Fn,Ln] = fibonacci(n)
% usage: [Fn,Ln] = fibonacci(n,modulus)
%
% Compute the nth Fibonacci number as well as the nth Lucas
% Lucas number. In the event that all members of these
% sequences from 1 to n are desired, then a simple,
% direct loop would be more efficient, and more direct.
%
% Both the Fibonacci numbers and the Lucas numbers
% are defined by the same basic recursion:
%
%  F(n) = F(n-1) + F(n-2)
%  L(n) = L(n-1) + L(n-2)
%
% The difference is the starting point. The Fibonacci
% numbers start with F(1) = F(2) = 1, whereas the Lucas
% sequence starts with L(1) = 1, and L(2) = 3. The first
% few members of these sequences are:
%
%  Fibonacci: [1 1 2 3 5 8 13 21 ... ]
%  Lucas:     [1 3 4 7 11 18 29 ... ]
%
% These sequences are also defined for n = 0 and for
% negative values of n.
%
% For efficiency, fibonacci uses a variety of tricks to
% maximize speed. While computation of fibonacci numbers
% is commonly done recursively, fibonacci does so using a
% direct iterative scheme given the binary representation
% of n. In addition, several Fibonacci and Lucas number
% identities are employed to maximize throughput.
%
% The methods employed by fibonacci will be O(log2(n)) in time.
%
%
% Arguments: (input)
%  n - any non-negative integer, vpi or numeric.
%      n must be less than 2^53 (in theory. Even that
%      number would be impossibly huge to compute.
%      Don't bother to try it.) In practice, recognize
%      that F(1e6) is a number with 208995 digits.
%
%      When n is a vector or array, fibonacci will
%      generate each of the indicated Fibonacci and
%      Lucas numbers.
%
%  modulus - (OPTIONAL) - allows the computation of the
%      indicated Fibonacci/Lucas numbers modulo a given
%      modulus. This enables the computation of such
%      numbers for truly immense index.
%
% Arguments: (output)
%  Fn, Ln - scalar vpi number, containing the nth
%      Fibonacci number and nth Lucas numbers in
%      their respective sequences.
%
% Example:
%  [Fn,Ln] = fibonacci(150)
%
% Fn =
%    9969216677189303386214405760200
% Ln =
%    22291846172619859445381409012498
%
%  See also: 
%
%  Author: John D'Errico
%  e-mail: woodchips@rochester.rr.com
%  Release: 1.0
%  Release date: 4/30/09

if (nargin < 1) || (nargin > 2)
  error('fibonacci accepts only 1 or 2 arguments')
elseif any(n(:)~=round(n(:))) || any(abs(n) > 2^53)
  error('n must be an integer, <= 2^53 in absolute value')
end

% was a modulus provided?
if (nargin < 2)
  modulus = [];
end

% The first 15 Fibonacci and Lucas numbers to
% start things off efficiently.
Fseq = [0 1 1 2 3  5  8 13 21 34  55  89 144 233 377  610];
Lseq = [2 1 3 4 7 11 18 29 47 76 123 199 322 521 843 1364];

if ~isempty(modulus)
  Fseq = mod(Fseq,modulus);
  Lseq = mod(Lseq,modulus);
end

% intialize Fn and Ln to the proper size,
% in case n is a vector or array
Fn = repmat(vpi(0),size(n));
Ln = Fn;

% much faster if n is not a vpi but a double.
% also, we don't need to worry about n being
% larger than 2^53, as this would have a vast
% number of digits.
n = double(n(:));

% catch any zeros in n first.
k = (n(:) == 0);
% Fn(k) is already zero
if any(k)
  Ln(k) = vpi(2);
end

% Negative values for n will be inconvenient
% in a loop, so make them all positive. deal
% with any signs later.
nsign = 2*(n>=0) - 1;
if any(n<0)
  neven = iseven(n);
  n = abs(n);
end

if numel(n) > 1
  % sort them and work upwards
  [n,ntags] = sort(n);
  
  flag = false;
  for i = 1:numel(n)
    if n(i) <= 15
      % small values of n are pre-computed
      Fn(i) = Fseq(n(i) + 1);
      Ln(i) = Lseq(n(i) + 1);
    elseif (i == 1) || ((n(i) - n(i-1)) > 15)
      % the smallest value of n is > 15,
      % or the difference from the last value
      % computed was too large
      [Fn(i),Ln(i)] = fibonacci(n(i),modulus);
      
      flag = false;
    elseif n(i) == n(i-1)
      % will happen if there were positive and
      % negative values in the list
      Fn(i) = Fn(i-1);
      Ln(i) = Ln(i-1);
      
      flag = false;
    elseif (n(i) == (n(i-1)+1))
      % we can use an addition formula to
      % get Fn & Ln. Which one?
      if flag
        % the last two values of n were
        % separated by 1, so just use the
        % two term recurrence
        Fn(i) = (Fn(i-1) + Fn(i-2));
        Ln(i) = (Ln(i-1) + Ln(i-2));
        if ~isempty(modulus)
          Fn(i) = mod(Fn(i),modulus);
          Ln(i) = mod(Ln(i),modulus);
        end
      else
        % we must use the addition formula
        Fn(i) = (Fn(i-1) + Ln(i-1))./2;
        Ln(i) = (5 .*Fn(i-1) + Ln(i-1))./2;
        if ~isempty(modulus)
          Fn(i) = mod(Fn(i),modulus);
          Ln(i) = mod(Ln(i),modulus);
        end
        
        % flag indicates whether the last two
        % numbers were consecutive
        flag = true;
      end
      
    else
      % 1 < n(i) - n(i-1) <= 15
      m = n(i) - n(i-1);
      Fm = Fseq(m+1);
      Lm = Lseq(m+1);
      
      % use an addition formula
      Fn(i) = (Fm.*Ln(i-1) + Lm.*Fn(i-1))./2;
      Ln(i) = (5 .*Fm.*Fn(i-1) + Lm.*Ln(i-1))./2;
      if ~isempty(modulus)
        Fn(i) = mod(Fn(i),modulus);
        Ln(i) = mod(Ln(i),modulus);
      end

      flag = false;
    end
    
  end % for i = 1:numel(n)
  
  % shuffle Fn and Ln to reflect the sort
  Fn(ntags) = Fn;
  Ln(ntags) = Ln;
  
else
  % For only one value of n, compute it individually.
  % Uses an efficient iterative (recursive, but not
  % really so) scheme.
  
  % get the binary representation of n. Thus
  % nbin is a character vector, of length
  % ceil(log2(n)).
  nbin = dec2bin(n);
  
  % get the 4 highest order bits from nbin
  k = min(numel(nbin),4);
  
  % start the sequence from the top
  % few bits of n.
  nhigh = bin2dec(nbin(1:k));
  
  Fn = vpi(Fseq(nhigh+1));
  Ln = vpi(Lseq(nhigh+1));
  
  % We need to loop forwards. Essentially, we started
  % with the highest order bit(s) of the binary representation
  % for n. Look at each successively lower order bit.
  % If the next bit is 0, then we are essentially doubling
  % the index at this step. If the next bit is odd, then
  % we are moving to 2*n+1.
  for k = 5:numel(nbin)
    bit = (nbin(k) == '1');
    if bit
      % the next bit was odd. Use
      % a 2*n+1 rule to step up.
      F2n = Fn.*Ln;
      % we want to do this...
      %   L2n = (5 .*Fn.*Fn + Ln.*Ln)./2;
      % Instead use the identity that
      %   5F(n)^2 + L(n)^2 = 2*L(n)^2 + 4*(-1)^(n+1)
      % to make that expression more efficiently
      % computed. See that the form used below
      % has only a single multiplication between a
      % pair of large integers, whereas the prior
      % form for L2n would have had several multiples
      % as well as a divide.
      L2n = Ln.*Ln + 2*(-1)^(nhigh+1);
      
      Fn = (L2n + F2n)./2;
      Ln = (5 .*F2n + L2n)./2;
      if ~isempty(modulus)
        Fn = mod(Fn,modulus);
        Ln = mod(Ln,modulus);
      end
    else
      % the next bit was even. Use the 2*n
      % rule to step up.
      F2n = Fn.*Ln;
      Ln = Ln.*Ln + 2*(-1)^(nhigh+1);
      Fn = F2n;
      if ~isempty(modulus)
        Fn = mod(Fn,modulus);
        Ln = mod(Ln,modulus);
      end
    end
    
    % update the top bits of n
    nhigh = 2*nhigh + bit;
  end % for k = 5:numel(nbin)
  
end % if numel(n) > 1

% if n was negative, then we may need to apply a
% sign change to Fn and Ln.
if any(nsign < 0)
  k = neven & (nsign < 0);
  Fn(k) = -Fn(k);

  k = (~neven) & (nsign < 0);
  Ln(k) = -Ln(k);
  
  if ~isempty(modulus)
    Fn(k) = mod(Fn(k),modulus);
    Ln(k) = mod(Ln(k),modulus);
  end
end

% ==================================
% End mainline, begin subfunctions.
% ==================================

function result = iseven(n)
% tests if a scalar value is an even integer, works
% for either numeric or vpi inputs
if isnumeric(n)
  result = (mod(n,2) == 0);
elseif isa(n,'vpi')
  % must have been a vpi
  result = (mod(trailingdigit(n,1),2) == 0);
else
  error('n must be either numeric or vpi')
end


