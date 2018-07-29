function y=dummybr(x,v)
% DUMMYBR
% DUMMYBR(x,v) creates a matrix of dummy variables corresponding to the elements of v
% x: Nx1 vector of data to be broken into dummies.
% v: (K-1)x1 vector specifying the k breakpoints (in ascending order) that
% define the k categories used to construct the dummy variables.
% y: NxK output matrix containing the k dummy variables.
% Example: v = [0;2;5]
% Will break up x in dummies such that: x <= 0, 0 < x and x <= 2, 2 < x and x <= 5
y=[];
[i j]=size(x);
if j~=1
   error('x must be a vector')
   else
nv=[-Inf; v];
for i=2:rows(nv);
   t=x<=nv(i) & x>nv(i-1);
   y=[y t];
end
end
