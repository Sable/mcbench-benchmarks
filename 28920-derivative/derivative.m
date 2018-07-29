function dx = derivative(x,N,dim)
% DERIVATIVE Compute derivative while preserving dimensions.
% 
% DERIVATIVE(X), for a vector X, is an estimate of the first derivative of X.
% DERIVATIVE(X), for a matrix X, is a matrix containing the first
%   derivatives of the columns of X.
% DERIVATIVE(X,N) is the Nth derivative along the columns of X.
% DERIVATIVE(X,N,DIM) is the Nth derivative along dimension DIM of X. 
% 
% DERIVATIVE averages neighboring values of the simple finite differencing
% method to obtain an estimate of the derivative that is exactly the same
% size as X. This stands in contrast to Matlab's built-in DIFF, which, when
% computing a derivative of order N on length M vectors, produces a vector
% of length M-N. DERIVATIVE is therefore useful for estimating derivatives
% at the same points over which X is defined, rather than in between
% samples (as occurs implicity when using Matlab's DIFF). This means that,
% for example, dX can be plotted against the same independent variables as
% X. Note that the first and last elements of DERIVATIVE(X) will be the
% same as those produced by DIFF(X).
%
% For N > 1, DERIVATIVE operates iteratively N times. If N = 0, DERIVATIVE
% is the identity transformation. Use caution when computing derivatives
% for N high relative to size(X,DIM). A warning will be issued.
% 
% Unless DIM is specified, DERIVATIVE computes the Nth derivative
% along the columns of a matrix input.
%
% EXAMPLE: 
% t = linspace(-4,4,500); x = normpdf(t); 
% dx = derivative(x); dt = derivative(t); 
% plot(t,x,t,dx./dt);
% 
% Created by Scott McKinney, October 2010
%
% See also GRADIENT

%set DIM
if nargin<3  
   if size(x,1)==1 %if row vector        
       dim = 2;
   else
       dim = 1; %default to computing along the columns, unless input is a row vector
   end
else           
    if ~isscalar(dim) || ~ismember(dim,[1 2])    
        error('dim must be 1 or 2!')
    end
end

%set N
if nargin<2 || isempty(N) %allows for letting N = [] as placeholder
    N = 1; %default to first derivative    
else        
    if ~isscalar(N) || N~=round(N)
        error('N must be a scalar integer!')
    end
end

if size(x,dim)<=1 && N
    error('X cannot be singleton along dimension DIM')
elseif N>=size(x,dim)
    warning('Computing derivative of order longer than or equal to size(x,dim). Results may not be valid...')
end

dx = x; %'Zeroth' derivative

for n = 1:N % Apply iteratively

    dif = diff(dx,1,dim);

    if dim==1
        first = [dif(1,:) ; dif];
        last = [dif; dif(end,:)];
    elseif dim==2;
        first = [dif(:,1) dif];
        last = [dif dif(:,end)];
    end
    
    dx = (first+last)/2;
end







    
        


