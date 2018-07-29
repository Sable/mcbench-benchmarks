function y = LaguerreGen(varargin)
%LaguerreGen calculates the generalized Laguerre polynomial L{n, alpha}
%
% This function computes the generalized Laguerre polynomial L{n,alpha}. 
% If no alpha is supplied, alpha is set to zero and this function 
% calculates the "normal" Laguerre polynomial.
%
% Input:
%  - n = nonnegative integer as degree level
%  - alpha >= -1 real number (input is optional)
%
% The output is formated as a polynomial vector of degree (n+1) 
% corresponding to MatLab norms (that is the highest coefficient is the 
% first element).
%
% Possible usage:
%  - polyval(LaguerreGen(n, alpha), x) evaluates L{n, alpha}(x)
%  - roots(LaguerreGen(n, alpha)) calculates roots of L{n, alpha}


% Calculation is done recursively using matrix operations for very fast
% execution time. The formula is taken from Szegö: Orthogonal Polynomials, 
% 1958, formula (5.1.10)


%   Author: Matthias.Trampisch@rub.de
%   Date: 16.08.2007
%   Version 1.2
 

%% ====================================================================== %
%              set default parameters and rename input
% ======================================================================= %
if (nargin == 1)        %only one parameter "n" supplied
        n = varargin{1};
        alpha = 0;      %set defaul value for alpha
elseif (nargin == 2)    %at least two parameters supplied
        n = varargin{1};
        alpha = varargin{2};
end;

%% ====================================================================== %
%                    error checking of input parameters
% ======================================================================= %
if (nargin == 0) || (nargin > 2) || (n~=abs(round(n))) || (alpha<-1)
        error('n must be integer, and (optional) alpha >= -1');
end;

%% ====================================================================== %
%        Recursive calculation of generalized Laguerre polynomial
% ======================================================================= %
L=zeros(n+1);          %reserve memory for faster storage
switch n
    case 0
        L(1,:)=1;
    otherwise           %n>1 so we need to do recursion
        L(1,:)=[zeros(1,n), 1];
        L(2,:)=[zeros(1, n-1), -1, (alpha+1)];
        for i=3:n+1
            A1 = 1/(i-1) * (conv([zeros(1, n-1), -1, (2*(i-1)+alpha-1)], L(i-1,:)));
            A2 = 1/(i-1) * (conv([zeros(1, n), ((i-1)+alpha-1)], L(i-2,:)));
            B1=A1(length(A1)-n:1:length(A1));
            B2=A2(length(A2)-n:1:length(A2));
            L(i,:)=B1-B2;    % i-th row corresponds to L{i-1, alpha}
        end;
end;

%% ====================================================================== %
%                               Define output
% ======================================================================= %
y=L(n+1,:);  %last row is the gen. Laguerre polynomial L{n, alpha}