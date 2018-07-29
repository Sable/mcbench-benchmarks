function R = ranort(alpha,N,h)
% Make matrix R_{N}^{alpha} that corresponds 
% to symmetric Riesz fractional differentiation
% using Ortiguieira's centred fractional differences
% Parameters:
%    alpha - order of differentiation (real, not necessarily integer)
%    N     - size of the resulting matrix R (N x N)
%    h     - step of discretization; default is h=1
%
% (C) 2008 Igor Podlubny, Blas Vinagre, Tomas Skovranek 
% 
% See:
% [1] I. Podlubny, A.Chechkin, T. Skovranek, YQ Chen, 
%     B. M. Vinagre Jara, "Matrix approach to discrete 
%     fractional calculus II: partial fractional differential 
%     equations". http://arxiv.org/abs/0811.1355
% [2] M. Ortigueira, "Riesz potential operators and inverses 
%     via fractional centred derivatives", 
%     International Journal of Mathematics and Mathematical 
%     Sciences, Vol. 2006, Article ID 48391, Pages 1-12,
%     DOI 10.1155/IJMMS/2006/48391

if nargin <= 1 || nargin > 3
    error('RANORT: Wrong number of input parameters')
else  
    k = 0:N-1;
    rc = ((-1)*ones(size(k))).^(k).*gamma(alpha+1).*(gamma(alpha*0.5 - k + 1).*gamma(alpha*0.5 + k + 1) ).^(-1);
    rc = rc * (cos(alpha*pi*0.5));
    R = zeros(N,N);
    for m = 1:N, 
        R(m, m:N) = rc(1:N-m+1); 
    end
    for i=1:N-1, 
        for j = i:N, 
            R(j,i)=R(i,j); 
        end
    end
end

if nargin == 3
    R = R*h^(-alpha);
end 
   