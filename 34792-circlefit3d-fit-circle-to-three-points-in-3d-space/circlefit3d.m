function [center,rad,v1n,v2nb] = circlefit3d(p1,p2,p3)
% circlefit3d: Compute center and radii of circles in 3d which are defined by three points on the circumference
% usage: [center,rad,v1,v2] = circlefit3d(p1,p2,p3)
%
% arguments: (input)
%  p1, p2, p3 - vectors of points (rowwise, size(p1) = [n 3])
%               describing the three corresponding points on the same circle.
%               p1, p2 and p3 must have the same length n.
%
% arguments: (output)
%  center - (nx3) matrix of center points for each triple of points in p1,  p2, p3
%
%  rad    - (nx1) vector of circle radii.
%           if there have been errors, radii is a negative scalar ( = error code)
%
%  v1, v2 - (nx3) perpendicular vectors inside circle plane
%
% Example usage:
%
%  (1)
%      p1 = rand(10,3);
%      p2 = rand(10,3);
%      p3 = rand(10,3);
%      [center, rad] = circlefit3d(p1,p2,p3);
%      % verification, result should be all (nearly) zero
%      result(:,1)=sqrt(sum((p1-center).^2,2))-rad;
%      result(:,2)=sqrt(sum((p2-center).^2,2))-rad;
%      result(:,3)=sqrt(sum((p3-center).^2,2))-rad;
%      if sum(sum(abs(result))) < 1e-12,
%       disp('All circles have been found correctly.');
%      else,
%       disp('There had been errors.');
%      end
%
%
% (2)
%       p1=rand(4,3);p2=rand(4,3);p3=rand(4,3);
%       [center,rad,v1,v2] = circlefit3d(p1,p2,p3);
%       plot3(p1(:,1),p1(:,2),p1(:,3),'bo');hold on;plot3(p2(:,1),p2(:,2),p2(:,3),'bo');plot3(p3(:,1),p3(:,2),p3(:,3),'bo');
%       for i=1:361,
%           a = i/180*pi;
%           x = center(:,1)+sin(a)*rad.*v1(:,1)+cos(a)*rad.*v2(:,1);
%           y = center(:,2)+sin(a)*rad.*v1(:,2)+cos(a)*rad.*v2(:,2);
%           z = center(:,3)+sin(a)*rad.*v1(:,3)+cos(a)*rad.*v2(:,3);
%           plot3(x,y,z,'r.');
%       end
%       axis equal;grid on;rotate3d on;
%
% 
% Author: Johannes Korsawe
% E-mail: johannes.korsawe@volkswagen.de
% Release: 1.0
% Release date: 26/01/2012

% Default values
center = [];rad = 0;v1n=[];v2nb=[];

% check inputs
% check number of inputs
if nargin~=3,
    fprintf('??? Error using ==> cirlefit3d\nThree input matrices are needed.\n');rad = -1;return;
end
% check size of inputs
if size(p1,2)~=3 || size(p2,2)~=3 || size(p3,2)~=3,
    fprintf('??? Error using ==> cirlefit3d\nAll input matrices must have three columns.\n');rad = -2;return;
end
n = size(p1,1);
if size(p2,1)~=n || size(p3,1)~=n,
    fprintf('??? Error using ==> cirlefit3d\nAll input matrices must have the same number or rows.\n');rad = -3;return;
end
% more checks are to follow inside calculation

% Start calculation
% v1, v2 describe the vectors from p1 to p2 and p3, resp.
v1 = p2 - p1;v2 = p3 - p1;
% l1, l2 describe the lengths of those vectors
l1 = sqrt((v1(:,1).*v1(:,1)+v1(:,2).*v1(:,2)+v1(:,3).*v1(:,3)));
l2 = sqrt((v2(:,1).*v2(:,1)+v2(:,2).*v2(:,2)+v2(:,3).*v2(:,3)));
if find(l1==0) | find(l2==0), %#ok<OR2>
    fprintf('??? Error using ==> cirlefit3d\nCorresponding input points must not be identical.\n');rad = -4;return;
end
% v1n, v2n describe the normalized vectors v1 and v2
v1n = v1;for i=1:3, v1n(:,i) = v1n(:,i)./l1;end
v2n = v2;for i=1:3, v2n(:,i) = v2n(:,i)./l2;end
% nv describes the normal vector on the plane of the circle
nv = [v1n(:,2).*v2n(:,3) - v1n(:,3).*v2n(:,2) , v1n(:,3).*v2n(:,1) - v1n(:,1).*v2n(:,3) , v1n(:,1).*v2n(:,2) - v1n(:,2).*v2n(:,1)];
if find(sum(abs(nv),2)<1e-5),
    fprintf('??? Warning using ==> cirlefit3d\nSome corresponding input points are nearly collinear.\n');
end
% v2nb: orthogonalization of v2n against v1n
dotp = v2n(:,1).*v1n(:,1) + v2n(:,2).*v1n(:,2) + v2n(:,3).*v1n(:,3);
v2nb = v2n;for i=1:3,v2nb(:,i) = v2nb(:,i) - dotp.*v1n(:,i);end
% normalize v2nb
l2nb = sqrt((v2nb(:,1).*v2nb(:,1)+v2nb(:,2).*v2nb(:,2)+v2nb(:,3).*v2nb(:,3)));
for i=1:3, v2nb(:,i) = v2nb(:,i)./l2nb;end

% remark: the circle plane will now be discretized as follows
%
% origin: p1                    normal vector on plane: nv
% first coordinate vector: v1n  second coordinate vector: v2nb

% calculate 2d coordinates of points in each plane
% p1_2d = zeros(n,2); % set per construction
% p2_2d = zeros(n,2);p2_2d(:,1) = l1; % set per construction
p3_2d = zeros(n,2); % has to be calculated
for i = 1:3,
    p3_2d(:,1) = p3_2d(:,1) + v2(:,i).*v1n(:,i);
    p3_2d(:,2) = p3_2d(:,2) + v2(:,i).*v2nb(:,i);
end

% calculate the fitting circle 
% due to the special construction of the 2d system this boils down to solving
% q1 = [0,0], q2 = [a,0], q3 = [b,c] (points on 2d circle)
% crossing perpendicular bisectors, s and t running indices:
% solve [a/2,s] = [b/2 + c*t, c/2 - b*t]
% solution t = (a-b)/(2*c)

a = l1;b = p3_2d(:,1);c = p3_2d(:,2);
t = 0.5*(a-b)./c;
scale1 = b/2 + c.*t;scale2 = c/2 - b.*t;

% centers
center = zeros(n,3);
for i=1:3,
    center(:,i) = p1(:,i) + scale1.*v1n(:,i) + scale2.*v2nb(:,i);
end

% radii
rad = sqrt((center(:,1)-p1(:,1)).^2+(center(:,2)-p1(:,2)).^2+(center(:,3)-p1(:,3)).^2);
