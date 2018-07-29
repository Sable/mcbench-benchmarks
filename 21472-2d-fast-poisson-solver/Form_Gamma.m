%
% Written by M. Harper Langston - 5/10/00
% harper@cims.nyu.edu
%
% Using Lemma 10.5, form the orthogonal matrix, Q, the block matrix of 
% matrices of eigenvectors of a TST block matrix. Then use this to form Gamma
% See Iselres page 246 or Lemma 10.5 for more info for Q.
% Gamma will be transformed into a plain tridiagonal matrix, using the method
% in Iserles, page 247 and 249.
function [Gam] = Form_Gamma(m,N)
for j = 1:m
   for k = 1:m
      Q(j,k) = sqrt(2/(m+1))*sin(pi*j*k/(m+1));
   end
end
% Now, form Gamma.  As per Iserles, page 247, we can rearrange columns into
% rows of the vectors, so Gamma will be tridiagonal.  The only difference is
% that in the problem, Gamma*t = c, solving for t, c must be converted and
% then t will have to be converted back.  See Iselres, pages 247 and 249
% for more informtion.
if N==9 | N==10
	S = (diag((-10/3)*ones(m,1)) + diag((2/3)*ones(m-1,1),1) + diag((2/3)*ones(m-1,1),-1));
   T = (diag((2/3)*ones(m,1)) + diag((1/6)*ones(m-1,1),1) + diag((1/6)*ones(m-1,1),-1));
elseif N==5
   S = (diag((-4)*ones(m,1)) + diag((1)*ones(m-1,1),1) + diag((1)*ones(m-1,1),-1));
   T = diag((1)*ones(m,1));
elseif N==101 % N = 101 is called by Modified_Right.m only, to  speed up
              % the modified 9=point scheme
   S = (diag((2/3)*ones(m,1)) + diag((1/12)*ones(m-1,1),1) + diag((1/12)*ones(m-1,1),-1));
   T = (diag((1/12)*ones(m,1)));
else
   error('Must either use 5 or 9-point scheme (N=5 or N=9 in poisson.m)');
end
% inv(Q) = Q, so don't need to invert Q to diagonalize S and T
GS = diag(Q*S*Q);
GT = diag(Q*T*Q);
Gam = sparse(zeros(size(Q)));
for j = 1:m
   temp = (j-1)*m +1;
   Gam(temp:j*m,temp:j*m) = diag(GS(j)*ones(m,1)) ...
	        + diag((GT(j))*ones(m-1,1),1) + diag((GT(j))*ones(m-1,1),-1);
end
Gam = sparse(Gam);
%
% Written by M. Harper Langston - 5/10/00
% harper@cims.nyu.edu
%