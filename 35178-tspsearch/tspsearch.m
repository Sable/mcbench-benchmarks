function [p,L] = tspsearch(X,m)
%TSPSEARCH Heuristic method for Traveling Salesman Problem (TSP).
%   [P,L] = TSPSEARCH(X,M) gives a tour P of length L. X is either a
%   coordinate matrix of size Nx2 or Nx3 or a symmetric distance matrix.
%   Euclidian distances are used in the coordinate case. M is an integer
%   in the range 1 to N. Default is M = 1.
%
%   METHOD
%   M nearest neighbour tours are generated from randomly selected starting
%   points. Each tour is improved by 2-opt heuristics (pairwise exchange of
%   edges) and the best result is selected.
%
%   EXAMPLES
%
%   X = rand(100,2);
%   [p,L] = tspsearch(X,100);
%   tspplot(p,X)
%
%   % Optimal tour length 1620
%   X = load('hex162.dat');
%   [p,L] = tspsearch(X,10);
%   tspplot(p,X)
%
%   % Optimal tour length 4860
%   X = load('hex486.dat');
%   [p,L] = tspsearch(X);
%   tspplot(p,X)

%   Author: Jonas Lundgren <splinefit@gmail.com> 2012

% Check first argument
[n,dim] = size(X);
if dim == 2 || dim == 3
    % X is a coordinate matrix, compute euclidian distances
    D = distmat(X);
elseif n == dim && min(X(:)) >= 0 && isequal(X,X')
    % X is a distance matrix
    D = X;
else
    mess = 'First argument must be Nx2, Nx3 or symmetric and nonnegative.';
    error('tspsearch:first',mess)
end

% Check second argument
if nargin < 2 || isempty(m)
    m = 1;
elseif ~isscalar(m) || m < 1 || m > n || fix(m) < m
    mess = 'M must be an integer in the range 1 to %d.';
    error('tspsearch:second',mess,n)
end

% Starting points for nearest neighbour tours
s = randperm(n);

Lmin = inf;
for k = 1:m
    % Nearest neighbour tour
	p = greedy(s(k),D);
    % Improve tour by 2-opt heuristics
	[p,L] = exchange2(p,D);
    % Keep best tour
	if L < Lmin
        Lmin = L;
        pmin = p;
	end
end

% Output
p = double(pmin);
L = Lmin;


%--------------------------------------------------------------------------
function D = distmat(X)
%DISTMAT Compute euclidian distance matrix from coordinates

[n,dim] = size(X);
D = zeros(n);
for j = 1:n
    for k = 1:dim
        v = X(:,k) - X(j,k);
        D(:,j) = D(:,j) + v.*v;
    end
end
D = sqrt(D);

%--------------------------------------------------------------------------
function p = greedy(s,D)
%GREEDY Travel to nearest neighbour, starting with node s.

n = size(D,1);
p = zeros(1,n,'uint16');
p(1) = s;

for k = 2:n
    D(s,:) = inf;
    [junk,s] = min(D(:,s)); %#ok
    p(k) = s;
end

%--------------------------------------------------------------------------
function [p,L] = exchange2(p,D)
%EXCHANGE2 Improve tour p by 2-opt heuristics (pairwise exchange of edges).
%   The basic operation is to exchange the edge pair (ab,cd) with the pair
%   (ac,bd). The algoritm examines all possible edge pairs in the tour and
%   applies the best exchange. This procedure continues as long as the
%   tour length decreases. The resulting tour is called 2-optimal.

n = numel(p);
zmin = -1;

% Iterate until the tour is 2-optimal
while zmin < 0

    zmin = 0;
    i = 0;
    b = p(n);

    % Loop over all edge pairs (ab,cd)
    while i < n-2
        a = b;
        i = i+1;
        b = p(i);
        Dab = D(a,b);
        j = i+1;
        d = p(j);
        while j < n
            c = d;
            j = j+1;
            d = p(j);
            % Tour length diff z
            % Note: a == d will occur and give z = 0
            z = (D(a,c) - D(c,d)) + D(b,d) - Dab;
            % Keep best exchange
            if z < zmin
                zmin = z;
                imin = i;
                jmin = j;
            end
        end
    end

    % Apply exchange
    if zmin < 0
        p(imin:jmin-1) = p(jmin-1:-1:imin);
    end

end

% Tour length
q = double(p);
ind = sub2ind([n,n],q,[q(2:n),q(1)]);
L = sum(D(ind));

