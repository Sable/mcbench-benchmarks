function Y = shift (U, k)
%
% For k>0,
%    this function shifts all coefficients of 
%    a matrix U in the north-east direction, 
% and for k<0,
%    it shifts all coefficients of 
%    a matrix U in the south-west direction.
% 
% The variable 'k' denotes the number of diagonals
% for shifting the matrix U.
% 
% (C) 2008 Igor Podlubny, Blas Vinagre, Tomas Skovranek
%
% See:
% [1] I. Podlubny, A.Chechkin, T. Skovranek, YQ Chen, 
%     B. M. Vinagre Jara, "Matrix approach to discrete 
%     fractional calculus II: partial fractional differential 
%     equations". http://arxiv.org/abs/0811.1355

s = size(U);
n = s(1);
absk = abs(k);
ek = diag(ones(1,n-absk),k);
s1 = eliminator(n,1:absk);
s2 = eliminator(n,(n-absk+1):n);

if k>0
    % shift north-east
    Y = s2*ek*U*ek*s1';
elseif k<0
    % shift south-west
    Y = s1*ek*U*ek*s2';
else
    % k = 0; do not shift
    Y = U;
end

