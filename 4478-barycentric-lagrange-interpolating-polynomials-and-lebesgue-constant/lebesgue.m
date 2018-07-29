function L=lebesque(x)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Computes the Lebesgue coefficient for a set of nodes on an interval
%
% References:
%
% (1) Jean-Paul Berrut & Lloyd N. Trefethen, "Barycentric Lagrange 
%     Interpolation" 
%     http://web.comlab.ox.ac.uk/oucl/work/nick.trefethen/berrut.ps.gz
% (2) Walter Gaustschi, "Numerical Analysis, An Introduction" (1997) p. 76+
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get number of nodes
n=length(x);

% use this finer mesh for interpolating between nodes
N=8*n+1;

x=x(:);

X=repmat(x,1,n);

% Compute the weights
w=1./prod(X-X'+eye(n),2);

% Fine mesh for interpolating 
xp=linspace(min(x),max(x),N)';

xdiff=repmat(xp.',n,1)-repmat(x,1,N);

% find all the points where the difference is zero
zerodex=(xdiff==0); 

% See eq. 3.1 in Ref (1)
lfun=prod(xdiff,1);

% kill zeros
xdiff(zerodex)=eps;

% Compute lebesgue function
lebfun=sum(abs(diag(w)*repmat(lfun,n,1)./xdiff));
plot(xp,lebfun);
L=max(lebfun);



