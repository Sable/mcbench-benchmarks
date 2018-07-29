function [totalVolume,totalArea] = stlVolume(p,t)
% Given a surface triangulation, compute the volume enclosed using
% divergence theorem.
% Assumption:Triangle nodes are ordered correctly, i.e.,computed normal is outwards
% Input: p: (3xnPoints), t: (3xnTriangles)
% Output: total volume enclosed, and total area of surface  
% Author: K. Suresh; suresh@engr.wisc.edu

% Compute the vectors d13 and d12
d13= [(p(1,t(2,:))-p(1,t(3,:))); (p(2,t(2,:))-p(2,t(3,:)));  (p(3,t(2,:))-p(3,t(3,:)))];
d12= [(p(1,t(1,:))-p(1,t(2,:))); (p(2,t(1,:))-p(2,t(2,:))); (p(3,t(1,:))-p(3,t(2,:)))];
cr = cross(d13,d12,1);%cross-product (vectorized)
area = 0.5*sqrt(cr(1,:).^2+cr(2,:).^2+cr(3,:).^2);% Area of each triangle
totalArea = sum(area);
crNorm = sqrt(cr(1,:).^2+cr(2,:).^2+cr(3,:).^2);
zMean = (p(3,t(1,:))+p(3,t(2,:))+p(3,t(3,:)))/3;
nz = -cr(3,:)./crNorm;% z component of normal for each triangle
volume = area.*zMean.*nz; % contribution of each triangle
totalVolume = sum(volume);%divergence theorem