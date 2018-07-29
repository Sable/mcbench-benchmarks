function S = eliminator(n, ROWS)
%
%ELIMINATOR
% 
% Returns a matrix S that is called eliminator.
% S is a matrix such that S*A (assuming that this product 
% exists) will not contain rows listed in row vector ROWS.
% Numbers of rows in ROWS can be unsorted.
%
% Example: 
%     A = hilb(6);
%     S = eliminator(6, [4 6 2]);
%     B = S * A; 
% Matrix B will contain rows 1, 3, 5 from the matrix A,
% matrix B will not contain rows 2, 4, 6 from matrix A.
% 
% (C) 2000 Igor Podlubny, Blas Vinagre, Tomas Skovranek 
%
% See:
% [1] I. Podlubny, A.Chechkin, T. Skovranek, YQ Chen, 
%     B. M. Vinagre Jara, "Matrix approach to discrete 
%     fractional calculus II: partial fractional differential 
%     equations". http://arxiv.org/abs/0811.1355
% [2] R.G. Cooke, Infinite Matrices and Sequence Spaces, 
%     MacMillan and Co., London, 1950. 347 pp.



S = eye(n); 
r = sort(ROWS);
m = size(r,2);

for k = m:(-1):1
   if r(k)-1 == 0 
        S = S((r(k)+1):(size(S,1)-k+1),:);
   elseif r(k) == size(S,1)
        S = S(1:(r(k)-1),:);
   else
        S = [S(1:(r(k)-1),:);  S((r(k)+1):(size(S,1)),:)];
   end    
end

