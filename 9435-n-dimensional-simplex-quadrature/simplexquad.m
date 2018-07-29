function [X,W]=simplexquad(varargin)

% simplexquad.m - Gaussian Quadrature for an n-dimensional simplex.
%
% Construct Gauss points and weights for a n-dimensional simplex 
% domain with vertices specified by the n*(n-1) matrix vert. Where each 
% row contains the coordinates (x1,...,xn) for a vertex. The order of
% the quadrature scheme in each dimension must be the same in this
% implementation.
%
% Sample Usage:
%
% [X,W]=simplexquad(n,vert); % Specify the vertices 
% [X,W]=simplexquad(n,dim);  % Specify the dimension and use unit simplex 
%
% X will be a matrix for which the jth column are the grid points in each
% coordinate xj. 
%
% Note: The standard n-dimensional simplex has vertices specified
%       vert=eye(n+1,n).
%
% The first four simplexes are
%
% n | Domain
% --|------------
% 1 | Interval 
% 2 | Triangle
% 3 | Tetrahedron
% 4 | Pentatope 
%
% Written by: Greg von Winckel  
% Contact: gregvw(at)math(dot)unm(dot)edu
% http://math.unm.edu/~gregvw

nargin=length(varargin);

if nargin~=2
    error('simplexquad takes two input arguments');
end

N=varargin{1}; 

if length(N)~=1
    error('First argument must be a scalar');
end

if N~=abs(round(N-1))+1;
    error('Number of Gauss points must be a natural number');
end
    
if length(varargin{2})==1  % Dimension specified
    n=varargin{2}; 
    
    if n~=abs(round(n-1))+1;
        error('Dimension must be a natural number');
    end    
    
    m=n+1; vert=eye(m,n);   
else                      % Vertices specified
    vert=varargin{2}; 
    [m,n]=size(vert);
    
    if m~=n+1 
        error('The matrix of vertices must have n+1 rows and n columns');
    end
end
    
Nn=N^n;

if n==1 % The 1-D simplex is only an interval
    [q,w]=rquad(N,0); len=diff(vert);
    X=vert(1)+len*q;  W=abs(len)*w;

else % Find quadrature rules for higher dimensional domains     

    for k=1:n 
        [q{k},w{k}]=rquad(N,n-k);
    end

    [Q{1:n}]=ndgrid(q{:}); q=reshape(cat(n,Q{:}),Nn,n);
    [W{1:n}]=ndgrid(w{:}); w=reshape(cat(n,W{:}),Nn,n);

    map=eye(m); map(2:m,1)=-1; c=map*vert;
    W=abs(det(c(2:m,:)))*prod(w,2);

    qp=cumprod(q,2); e=ones(Nn,1);
    X=[e [(1-q(:,1:n-1)),e].*[e,qp(:,1:n-2),qp(:,n)]]*c;
end


function [x,w]=rquad(N,k)

k1=k+1; k2=k+2; n=1:N;  nnk=2*n+k;
A=[k/k2 repmat(k^2,1,N)./(nnk.*(nnk+2))];
n=2:N; nnk=nnk(n);
B1=4*k1/(k2*k2*(k+3)); nk=n+k; nnk2=nnk.*nnk;
B=4*(n.*nk).^2./(nnk2.*nnk2-nnk2);
ab=[A' [(2^k1)/k1; B1; B']]; s=sqrt(ab(2:N,2));
[V,X]=eig(diag(ab(1:N,1),0)+diag(s,-1)+diag(s,1));
[X,I]=sort(diag(X));    
x=(X+1)/2; w=(1/2)^(k1)*ab(1,2)*V(1,I)'.^2;