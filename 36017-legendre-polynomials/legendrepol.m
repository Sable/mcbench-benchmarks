function P = legendrepol(N, a, b)
%-------------------------------------------------------------------------
%
%       P = legendrepol(N)
%
% returns the Legendre polynomials up to order N, orthogonal on
% the interval [-1,1]. Each row contain the polynomial coefficients in 
% descending order, i.e. the first row is P0 = [0 0 .... 1].
%
%       P = legendrepol(N),xmin,xmax)
% 
% returns the Legendre polynomial orthogonal on [xmin, xmax].
%-------------------------------------------------------------------------

% T. Wik, April 2012

% L is the Legendre polynomials orthogonal on (-1,1):
if N<1
	L = 1;
else
	L 		   = zeros(N+1,N+1);
	L(1,N+1)   = 1;              % L0
	L(2,N:N+1) = [1 0];          % L1
   for n=1:N-1                   % L2 to LN 
   	L(n+2,N-n:N+1) 	= 1/(n+1)* ...
                   	 ((2*n+1)*[L(n+1,N+1-n:N+1) 0]-n*[0 0 L(n,N+2-n:N+1)]);
   end
end

if nargin == 3
    if a > b
        error('legendrepol:wrongArguments','xmin > xmax !')
    end
% Transform such that P is orthogonal on (xmin,xmax):
    P = zeros(N+1);
    A = zeros(N+1);

    for n = 1:N+1
        A(end-n+1,end-n+1:end) = binomial(n-1,2/(b-a),-(a+b)/(b-a));
        Lambda  = diag(L(n,:));
        P(n,:) = sum(Lambda*A);
    end
elseif nargin == 1
        P = L;
else
    error('legendrepol:wrongArguments','Use one or three arguments!')
end  
    
    


function P = binomial(n,a,b)
%------------------------------------------------------
%
% function P = binomial(n,a,b)
%
% Returns the polynomial coefficients p(i) for
%
% P(x) = (ax + b)^n
%      = p(1)x^n + p(2)x^(n-1) + ... + p(n)x + p(n+1)
%
%------------------------------------------------------

% First binomial coefficients for (x+1)^n

if n==0, P=1; return, end
p = zeros(n,n+1);

p(1,1:2) = [1 1];

for j = 2:n
    p(j,1) = 1;
    for k = 2:n
        p(j,k) = p(j-1,k-1) + p(j-1,k);
    end
    p(j,n+1) = 1;
end

% Adjust for a and b

for k = 1:n+1;
    P(k) = p(n,k)*a^(n-k+1)*b^(k-1);
end
