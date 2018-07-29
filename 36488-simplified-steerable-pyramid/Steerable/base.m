function [log_rad,angle]=base(m,n)
% Compute radius and angle matrix base for a given size of m,n
% Input:
%       m:  number of rows
%       n:  number of cols
% Output:
%   log_rad:    radius matrix, store the distance between a pixel and
%               the center of matrix
%     angle:    angle matrix, store the angle of a pixel

ctrm=ceil(m/2);
ctrn=ceil(n/2);

% x span from -m/2 to m/2 with interval 2/m
[x,y] = meshgrid(( (1:m)-ctrm)/(m/2),( (1:n)-ctrn)/(n/2));

% radius matrix
rad = sqrt(x.^2 + y.^2);
rad(m/2,n/2) =  rad(m/2,n/2-1);
log_rad  = log2(rad); 

% angle matrix
angle = atan2(y,x); 