function aliquots = aliquotparts(N)
% aliquotparts: list all of the proper divisors of N, the aliquot parts of N
% usage: aliquots = aliquotparts(N)
%
% A proper divisor (of a positive integer N) is a number less than
% N that divides N with a zero remainder and a positive integer
% quotient. It is sometimes known as an aliquot part. The sum of
% the proper divsors is also known as the aliquot sum.
%
%  http://en.wikipedia.org/wiki/Divisor_function
%  http://en.wikipedia.org/wiki/Aliquot
%
%
% arguments: (input)
%  N     - A positive integer (scalar)
%          N cannot exceed 2^32.
%
% arguments: (Output)
%  aliquots - a row vector that lists all of the proper
%          divisors (aliquot parts) of N.
%
%
% Example:
%   aliquots(12)
%   ans =
%       1  2  3  4  6
%
%
% See also: aliquotsum, amicablecycles, factor, primes, vpi
% 
%
% Author: John D'Errico
% e-mail: woodchips@rochester.rr.com
% Release: 1.0
% Release date: 9/21/08

% test that N is a positive integer.
if (nargin~=1) || isempty(N)
  error('You must provide N, and no other arguments')
end
% is N a positive integer?
if any(N<0) || any(N~=floor(N)) || (any(N>2^32) && ~isa(N,'vpi'))
  error('N must be a positive scalar integer <= 2^32, or a list thereof')
end

% The prime factors of N
f = factor(N);

% and their frequencies
[uf,i,j] = unique(f); % Don't use i
count = accumarray([ones(length(j),1),j'],1);

aliquots = uf(1).^[0:count(1)];
for i = 2:length(uf)
  aliquots = kron(aliquots,uf(i).^[0:count(i)]);
end
aliquots = sort(aliquots);

% but do not include N itself
aliquots(end) = [];

