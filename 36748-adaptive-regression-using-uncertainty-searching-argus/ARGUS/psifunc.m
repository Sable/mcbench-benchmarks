function psi = psifunc(centers,x,dis)
%This function is the psi second order spline function
% If other orders are desired, this function can be replaced
% centers are the knot locations
%x is a nxd matrix where d is the dimension and n are the number of points
%dis is an optional distance matrix. If it is not supplied, simple
% Euclidean distance will be calculated. This can also be used to save
% computational time if the matrix is calculated elsewhere

if nargin<3
    dis = pdist2(centers,x);
end
r=dis.*dis;
r(r==0)=1;
psi=r.*log(r);
end