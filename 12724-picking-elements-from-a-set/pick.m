% pick    Picking elements from a set (combinations, permutations)
%
%   s = pick(V,k,Type)
%
%   Gives all possibilities of picking k elements from the
%   set V with or without order and repetition. V can be an
%   array of any size and any type.
%
%   Type can have the following values: '', 'o', 'r', 'or'.
%     'o' means pick ordered set of k elements
%     'r' means replace elements after picking
%
%   s is an array with all picks, one subset per row.
%
%   Examples
%     pick(1:2,5,'or')
%     pick('abcd',2,'')
%     pick(-1:1,4,'r')
%     pick('X':'Z',3,'o')

% Stefan Stoll, ETH Zurich, 20 October 2006

function s = pick(V,k,Type)

errThirdMissing = 'Third argument Type ('''', ''o'', ''r'', or ''or'') is missing!';
errThreeExpected = 'Three arguments (V, k, Type) must be provided.';

switch nargin
  case 3,
  case 2, error(errThirdMissing);
  case 1,
    if strcmp(V,'test');
      pick_test;
      return;
    else
      error(errThreeExpected);
    end
  case 0, help(mfilename); return;
  otherwise, error(errThreeExpected);
end

N = numel(V);

if (N==0)
  error('First argument V must be an array with at least one element.');
end

if (numel(k)~=1) || rem(k,1) || (k<1)
  k
  error('Second argument k must be a positive integer. You gave the above.');
end

if ~ischar(Type)
  Type
  error('Third argument must be a string.');
end

if isempty(strfind(Type,'r')) && (k>N)
  str = sprintf('Picking elements without repetition:\n  k must not be larger than the number of elements in V.\n');
  error([str 'You gave k=%d for %d elements in V.'],k,N);
end

switch sort(Type)
  case '',   idx = combinations_without_repetition(N,k);
  case 'o',  idx = permutations_without_repetition(N,k);
  case 'r',  idx = combinations_with_repetition(N,k);
  case 'or', idx = permutations_with_repetition(N,k);
  otherwise
    Type
    error('Third argument Type must be one of '''', ''o'', ''r'', ''or''.');
end

s = V(idx);
if (k==1), s = s(:); end

return

%=====================================================================
function m = combinations_with_repetition(N,k)

if (k==1), m = (1:N).'; return; end
if (N==1), m = ones(1,k); return; end

m = [];
for q = 1:N
  mnext = combinations_with_repetition(N+1-q,k-1);
  m = [m; q*ones(size(mnext,1),1), mnext+q-1];
end


%===================================================================
function p = permutations_without_repetition(N,k)

p = permutations_with_repetition(N,k);
ps = sort(p.').';
idx = any(ps(:,2:end)==ps(:,1:end-1),2);
p(idx,:) = [];


%===================================================================
function s = permutations_with_repetition(N,k)

if (k==1), s = (1:N).'; return; end
if (N==1), s = ones(1,k); return; end

[idx{1:k}] = ndgrid(1:N);
s = fliplr(reshape(cat(ndims(idx{1}),idx{:}),[],k));


%===================================================================
function c = combinations_without_repetition(N,k)

if (N>1)
  c = nchoosek(1:N,k);
else
  c = 1;
end


%===================================================================
function pick_test

disp('=========== pick() tests ======================');

Nmax = 6;

Type = {'','o','r','or'};
Name{1} = 'Combinations without repetition';
Name{2} = 'Permutations without repetition';
Name{3} = 'Combinations with repetition';
Name{4} = 'Permutations with repetition';
Repetition = [0 0 1 1];

for t = 1:4
  disp(' ');
  disp(Name{t});
  for N = 1:Nmax
    if Repetition(t), kmax = Nmax; else kmax = N; end
    for k = 1:kmax
      s = pick(uint8(1:N),k,Type{t});
      m1 = size(s,1); k1 = size(s,2);
      switch t
        case 1, m = nchoosek(N,k);
        case 2, m = prod(N-k+1:N);
        case 3, m = nchoosek(N+k-1,k);
        case 4, m = N^k;
      end
      fprintf('  N=%d, k=%d, expected %dx%d, found %dx%d\n',N,k,m,k,m1,k1);
      if (m1~=m) | (k1~=k)
        error('Unexpected size of output array!');
      end
    end
  end
end
disp('All tests passed!');
