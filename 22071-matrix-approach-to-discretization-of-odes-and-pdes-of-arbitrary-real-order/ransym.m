function R = ransym(alpha,N,h)
% Make matrix R_{N}^{alpha} that corresponds 
% to symmetric Riesz fractional derivative as 
% a half-sum of left- and right-sided Caputo derivatives.
% Parameters:
%    alpha - order of differentiation (real, not necessarily integer)
%    N     - size of the resulting matrix B (N x N)
%    h     - step of discretization; default is h=1
%
% (C) 2008 Igor Podlubny, Blas Vinagre, Tomas Skovranek 
%
% See the following articles:
% [1] I. Podlubny, "Matrix approach to discrete fractional calculus",
%     Fractional Calculus and Applied Analysis, 
%     vol. 3, no. 4, 2000, pp. 359-386. 
%     http://people.tuke.sk/igor.podlubny/pspdf/ma2dfc.pdf
% [2] I. Podlubny, A.Chechkin, T. Skovranek, YQ Chen, 
%     B. M. Vinagre Jara, "Matrix approach to discrete 
%     fractional calculus II: partial fractional differential 
%     equations". http://arxiv.org/abs/0811.1355

if nargin <= 1 || nargin > 3
    error ('RANSYM: Wrong number of input parameters')
else
    B = ban (alpha, N+1);
    BM = B(2:(N+1), 1:N);
    R = 0.5 * (BM + BM');
end

if nargin == 3
    R = h^(-alpha)*R;
end 
   