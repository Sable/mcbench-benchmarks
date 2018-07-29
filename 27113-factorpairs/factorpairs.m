function pq = factorpairs(N)
% factorpairs: all pairs of distinct integer factors (p,q), such that p.*q == N
% usage: pq = factorpairs(N)
%
% arguments: (input)
%  N  - any scalar positive integer, 1 <= n <= 2^32
%
% arguments: (output)
%  pq - a mx2 array of all positive integer
%       pairs such that prod(pq,2) == n
%       The first element of each pair is
%       always the smaller of the two factors.
%
%
% Example:
% factorpairs(72)
% % ans =
% %     1    72
% %     2    36
% %     3    24
% %     4    18
% %     6    12
% %     8     9
%
%
% Example:
% tic,F = factorpairs(factorial(12));toc
% % Elapsed time is 0.003767 seconds.
%
% size(F)
% % ans =
% %   396     2
%
%
% See also: factor, aliquotparts, nfactork
%
% 
% Author: John D'Errico
% e-mail: woodchips@rochester.rr.com
% Release: 1.0
% Release date: 3/29/2010

% initialization checks and error tests
if nargin ~= 1
  error('FACTORPAIRS:invalidarguments','Exactly one argument must be provided.')
end
if isempty(N)
  % empty begets empty
  pq = [];
  return
end
% verify that N is scalar, positive integer
if (numel(N) > 1) || (N <= 0) || (N~= round(N))
  error('FACTORPAIRS:invalidarguments','N must be scalar, positive, integer.')
end

% a few simple special cases
if N == 1
  pq = [1 1];
  return;
elseif isprime(N)
  pq = [1 N];
  return;
end

% N must now be composite. Extract the factors of N
% This is why N must be no more than 2^32, as factor
% will not accept any larger number. I could allow vpi
% numbers here, I suppose...
F = factor(N).';

% Determine multiplicities of those factors
[unikF,I,J] = unique(F);
countF = accumarray(J,1);
nF = numel(unikF);

% for each unique factor, get the factor pairs
pqF = cell(1,nF);
for i = 1:nF
  % ni must always be at least 1
  ni = countF(i);
  Fi = unikF(i);
  if ni == 1
    % special case, a single prime factor
    fpows = [0 1];
  elseif mod(ni,2) == 0
    % general case: ni is even
    n2 = ni/2;
    fpows = [0:n2;ni:-1:n2].';
  else
    % general case: ni is odd
    n2 = (ni - 1)/2;
    fpows = [0:n2;ni:-1:(n2+1)].';
  end
  pqF{i} = Fi.^fpows;
end

% combine the factor pairs in pqF into one
% set of factor pairs
pq = pqF{1};
for i = 2:nF
  pqi = pqF{i};
  pq = [[kron(pq(:,1),pqi(:,1)),kron(pq(:,2),pqi(:,2))]; ...
    [kron(pq(:,1),pqi(:,2)),kron(pq(:,2),pqi(:,1))]];
  pq = unique(sort(pq,2),'rows');
end



