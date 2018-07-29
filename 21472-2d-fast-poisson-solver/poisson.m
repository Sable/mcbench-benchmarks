% poisson(m,endpt,N) - (m,endpt and N are described below)
%
% Written by M. Harper Langston - 5/10/00
% harper@cims.nyu.edu
%
% Fast poisson solver implementation in a SQUARE with CONTINUOUS DIRICHLET BNDRY CONDS.
% This file requires quite a few additional files:
%
% These first two are the only ones that need to be changed, depending on the situation:
% Form_Boundary.m - Stores the Dirichlet boundary condition
% ffunc.m - Stores f(x,y)
%
% The rest of these files are necessary, but MUST NOT BE changed (except by
% expert hands :) so that everything works ok)
% Form_Right.m - returns the right-hand side of the problem, given the boundary conditions
%                and the vector, f.  The result, b, incorporates boundary correction
% Modified_Right.m - Called in Form_Right.m, for the modified-nine-point scheme.
%                    This returns the matrix, B, which multiplies f(x,y)
% Form_Gamma.m - Forms the block matrix, Gamma, the block (tridiagonal) matrix of e-values.
%                It does this by forming Q and then diagonalizing each block in A.
%                It's important to note that Q is orthogonal such that inv(Q) = Q;
%                This makes computation faster when we need it.
% Band_Solve.m - Finds the band of a Matrix and solves Ax = b
%                according to A's sparsity and then does sparse LU decomposition
% Back_Solve.m - Called by Band_Solve.m to do the actual solving.  It is a separate
%                function since Band_Solve calls it twice.
% Transform.m - Last, but not least, Transform.m contains the call to the 
%               discrete fourier transform, and implements a fast sine transform
%               by looking only at the imaginary part, up to a scaling factor.
%               This is used to quickly compute y = Q*b and u = Q*y where the
%               eigenvector-columns of Q are already known.

function poisson(m,endpt,N)
% m = refinement of mesh (best to keep below 100 on a 300 MhZ Home PC if you ever want it
%     to finish; you can test this on your system).  
%     Note that x and y are discretized in the same manner.
% endpt = the endpoint of x and y, i.e., 0<x,y<endpt
% N = the scheme you wish to use.  For the 5-point scheme, N = 5,
%     for the 9-point scheme, N = 9, 
%     and for the modified 9-point scheme, N=10.

% Calculation of h and x,y, depending on endpt
h1 = endpt/(m+1);  h2 = endpt/(m+1);
x = 0:h1:endpt;  y = 0:h2:endpt;
[xnew,ynew] = meshgrid(x,y);
% The right hand side, f, is in ffunc.m
f = ffunc(xnew,ynew);
% The boundary conditions, gtop, gbot, gleft and gright are all formed by
% Form_Boundary.m  Here, gb = bottom bndry cond. (u(x,0)), gt the top one (u(x,pi))
% , gr the right one (u(pi,y)), and gl the left one (u(0,y)).  See Form_Boundary.m
[gb,gt,gl,gr] = Form_Boundary(x,y);
% Form_Right.m forms the right hand side of the problem, b
[Gam] = Form_Gamma(m,N);
b = Form_Right(m,h1,f,gb,gt,gl,gr,N);
% Call the DF sine Transform routine for speed:
c = Transform(m,b)';
% Having formed c, rearrange rows into columns, so have to convert c to
% matrix format.  Only takes O(m) time which is negligible
for j = 1:m
   cnew(1:m,j) = c((j-1)*m + 1:(j-1)*m + m);
end
c = cnew';   c = c(:);
% Now, since Gamma is tridiagonal, with bandwidth 1, using Band_Solve
% is cheap, costing O(m^2) time
t = Band_Solve(Gam,c);
% The resulting vector t must be rearranged back so columns are rows: O(m)
for j = 1:m
   tnew(1:m,j) = t((j-1)*m + 1:(j-1)*m + m);
end
t = tnew';   t = t(:);
% Call the DF sine Transform routine for speed to get the final result,u:
u = Transform(m,t)';
% For a mesh of the u vector by putting it back into matrix format.  Takes O(m)
for j = 1:m
   unew(1:m,j) = u((j-1)*m + 1:(j-1)*m + m);
end
unew = [gb(2:length(gt)-1);unew;gt(2:length(gb)-1)];
unew = [gl',unew,gr'];
figure(1)
mesh(xnew,ynew,unew,'EdgeColor','black');
xlabel('x'); ylabel('y'); zlabel('Solution, u')
%
% Written by M. Harper Langston - 5/10/00
% harper@cims.nyu.edu
%