function y=dummy(x,v)
% DUMMY
% DUMMY(x,v) creates a matrix of dummy variables corresponding to the elements of v
% x: Nx1 vector of data to be broken into dummies.
% v: (K-1)x1 vector specifying the k-1 breakpoints (in ascending order) that
% define the k categories used to construct the dummy variables.
% y: NxK output matrix containing the k dummy variables.
% Example: v =[0;2;4]
% Will break x such that: x <= 0, 0 < x .and x <= 2, 2 < x .and x <= 4, 4 < x
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
end
