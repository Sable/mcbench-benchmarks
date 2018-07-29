function B = ban(alpha,N,h)
% Make matrix B_{N}^{alpha} that corresponds 
% to left-sided Riemann-Liouville fractional differentiation
% Parameters:
%    alpha - order of differentiation (real, not necessarily integer)
%    N     - size of the resulting matrix B (N x N)
%    h     - step of discretization; default is h=1
%
% (C) 2000 Igor Podlubny 
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

B = zeros(N,N);
if nargin <= 1 || nargin > 3
    error('BAN: Wrong number of input parameters')
else 
    bc=fliplr(bcrecur(alpha,N-1));
    for k=1:N
       B(k,1:k)=bc((N-k+1):N);
    end
end

if nargin == 3
    B=h^(-alpha)*B;
end 
   