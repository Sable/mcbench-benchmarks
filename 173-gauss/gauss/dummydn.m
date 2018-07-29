function y=dummydn(x,v,p)
% DUMMYDN
% DUMMYDN(x,v,p) creates a matrix of dummy variables corresponding to the elements of v
% x: Nx1 vector of data to be broken into dummies.
% The pth vector of dummies is deleted so that the dummy matrix is not colinear with a vector of ones.
% v: Kx1 vector specifying the k-1 breakpoints (in ascending order) that
% define the k categories used to construct the dummy variables.
% y: NxK output matrix containing the k dummy variables.
y=[];
[i j]=size(x);
if j~=1
   error('x must be a vector')
   else
nv=[-Inf; v; +Inf];
for i=2:rows(nv);
   t=x<=nv(i) & x>nv(i-1);
   y=[y t];
end
y(:,p)=NaN;
y=(packr(y'))';
end
