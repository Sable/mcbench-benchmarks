% Copyright (C) 2012 Quan Wang <wangq10@rpi.edu>, 
% Signal Analysis and Machine Perception Laboratory, 
% Department of Electrical, Computer, and Systems Engineering, 
% Rensselaer Polytechnic Institute, Troy, NY 12180, USA
% 
% You are free to use this software for academic purposes if you cite our paper: 
% Quan Wang, Kim L. Boyer, 
% The active geometric shape model: A new robust deformable shape model and its applications, 
% Computer Vision and Image Understanding, Volume 116, Issue 12, December 2012, Pages 1178-1194, 
% ISSN 1077-3142, 10.1016/j.cviu.2012.08.004. 
% 
% For commercial use, please contact the authors. 

function [x,y,theta]=spline_contour_in_image(m,n,xc,yc,D)
%%  Return discrete coordinates of points on a spline contour.
%   The functions of the spline contour: 
%       x=xc+xspline(D(1),...,D(N))
%       y=yc+yspline(D(1),...,D(N))
%   m: number of rows of image
%   n: number of columns of image
%   D: vector of the distances from landmarks to center (row vector)

% N: number of landmarks of the spline contour
N=max(size(D));

theta=linspace(0,2*pi,round( 2*pi*max(D) ));
% lm: landmark
lm_theta=linspace(0,2*pi,N+1);
DD=myspline(lm_theta,D,theta);

data=[xc+DD.*cos(theta);...
    yc+DD.*sin(theta)];
data=round(data);
[data index1 index2]=unique(data','rows'); % remove repeated points
data=data';
x=data(1,:);
y=data(2,:);
theta=theta(index1);
[theta index]=sort(theta);
x=x(index);
y=y(index);
if min(x)<1 || min(y)<1 || max(x)>n || max(y)>m
    fprintf('\n\nError: Contour out of image!\n\n');
end