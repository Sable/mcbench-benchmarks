function cycles = amicablecycles(N,L)
% amicable: generate a list of amicable cycles of numbers
% usage: cycles = amicablecycles(N)
% usage: cycles = amicablecycles(N,L)
%
% Amicable number pairs are numbers such that the sum of their proper
% divisors add up to the other number in the pair. For example, the 
% proper divisors of 220 are: {1, 2, 4, 5, 10, 11, 20, 22, 44, 55, 110}.
% Their sum is 284. And the proper divisors of 284 are {1, 2, 4, 71, 142}.
% Their sum is 220. So (220,284) is an amicable pair of numbers. Perfect
% numbers are self-amicable, since the sum of their proper divisors is
% the number itself. Perfect numbers have a cycle length of 1.
%
% Numbers that generate cycles of length more than 2 are called
% sociable numbers. For example, the sociable sequence
%
%  [12496 14288 15472 14536 14264 12496]
%
% has length 5 before it returns to the first member of that sequence.
% The sum of proper divisors of each member is the next member of the
% sequence.
%
%
% arguments: (input)
%  N - scalar (positive) integer - defines the largest number
%      which will be tested as a member of a pair of amicable
%      numbers.
%
%      If N is a vector of integers, then it defines the list
%      of values which will be tested as the first element in
%      amicable cycle of length L.
%
%  L - the length of the sequences that will be generated
%      If L is not provided, a default value of 2 will be
%      assumed. This will generate amicable pairs of numbers.
%      L == 1 will generate perfect numbers.
%
%
% arguments: (Output)
%  pairs - an array with two columns, containing all amicable pairs found
%
% 
% Example:
%  All amicable pairs starting less than 20000
%
% amicablecycles(20000,2)
% ans =
%         220         284
%        1184        1210
%        2620        2924
%        5020        5564
%        6232        6368
%       10744       10856
%       12285       14595
%       17296       18416
%
%
% See also: aliquotsum, aliquotparts, factor, primes
% 
%
% Author: John D'Errico
% e-mail: woodchips@rochester.rr.com
% Release: 1.0
% Release date: 9/21/08


% test that N is a scalar and a positive integer.
if nargin<1
  error('You must provide a scalar integer N')
end
N = N(:);
if any(N<=0) || any(N~=floor(N))
  error('N must be a positive scalar integer, or a vector of positive integers')
end

if (nargin<2) || isempty(L)
  L = 2;
elseif (numel(L)~=1) || (L < 1) || (L~=floor(L))
  error('L must be a positive integer scalar if provided.')
end

% list of all numbers up to N
if length(N) == 1
  list = (1:N)';
else
  list = N;
  N = length(list);
end
sequences = [list,zeros(N,L)];

% get the aliquot sum (sum of proper divisors)
% for each member of list, and repeat the operation
% L times.
for i = 1:L
  pdsum = aliquotsum(sequences(:,i));
  if i<L
    pdsum(pdsum == list) = 0;
  end
  sequences(:,i+1) = pdsum;
end
k = (sequences(:,1) == sequences(:,L+1));
cycles = sequences(k,1:L);

% Cycles of length >1 will show up multiple times.
% We only want the first instance found.
if L>1
  c = sort(cycles,2);
  [junk,i] = unique(c,'rows','first');
  cycles = cycles(i,:);
end


