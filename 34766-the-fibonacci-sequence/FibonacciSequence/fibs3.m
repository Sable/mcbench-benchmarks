function [Fn,Ln] = fibs3(n)
% fibs: vpi tool to efficiently compute the n'th Fibonacci number and the n'th Lucas number
% usage: [Fn,Ln] = fibs3(n)
%
% For efficiency, fibs3 uses a variety of tricks to
% maximize speed. While computation of fibonacci numbers
% is commonly done recursively, fibs3 does so using a
% direct iterative scheme given the binary representation
% of n. In addition, several Fibonacci and Lucas number
% identities are employed to maximize throughput.
%
% The methods employed by fibs3 will be O(log2(n)) in time.

if (nargin~=1) || (numel(n) ~= 1) || (n~=round(n)) || (abs(n) > 2^53)
  error('n must be scalar and an integer, <= 2^53 in absolute value')
end

% much faster if n is not a vpi but a double.
% also, we don't need to worry about n being
% larger than 2^53, as this would have a vast
% number of digits.
n = double(n);

% ensure that n is positive, handle the negative
% cases later.
nsign = sign(n);
n = abs(n);

% get the binary representation of n. Thus
% nbin is a character vector, of length
% ceil(log2(n)).
nbin = dec2bin(n);

% get the 4 highest order bits from nbin
k = min(numel(nbin),4);

% zero is a special case to stop at.
if n == 0
  Fn = vpi(0);
  Ln = vpi(2);
  return
else
  % start the sequence from the top
  % few bits of n.
  nhigh = bin2dec(nbin(1:k));
  Fseq = [1 1 2 3  5  8 13 21 34  55  89 144 233 377  610];
  Lseq = [1 3 4 7 11 18 29 47 76 123 199 322 521 843 1364];
  
  Fn = vpi(Fseq(nhigh));
  Ln = vpi(Lseq(nhigh));
end

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
  else
    % the next bit was even. Use the 2*n
    % rule to step up.
    F2n = Fn.*Ln;
    Ln = Ln.*Ln + 2*(-1)^(nhigh+1);
    Fn = F2n;
  end
  
  % update the top bits of n
  nhigh = 2*nhigh + bit;
end

% if n was negative, then we may need to apply a
% sign change to Fn and Ln.
if nsign < 0
  if iseven(n)
    Fn = (-nsign).*Fn;
    Ln = nsign.*Ln;
  else
    Fn = nsign.*Fn;
    Ln = (-nsign).*Ln;
  end
end

% ==================================
% End mainline, begin subfunctions.
% ==================================

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


