function [coordSys,as] = animEuler(h,rotSet,angs)
% animEuler animates sets of arbitrary Euler rotations. 
% 
% [coordSys,as] = animEuler(h,rotSet,angs) animates the rotation of a
% dextral coordinate system using three arbitrary Euler angles (angs) about
% three axes (rotSet) in figure (h).  rotSet is an array of 3 numbers in
% the range of [1, 3] representing the three body axes, so that rotSet =
% [3,1,3] is a body 3-1-3 rotation (z-x-z convention).  Angles are assumed
% to be in degrees.  In addition to animating the rotations, this function
% plots the intermediate reference frames.
%
% The function returns the matrix coordSys, representing the direction
% cosine matrix of the Euler angle set, and the array (as), containing the
% handles of the three surfact objects representing the axes.
%
% Note: If called with no arguments, this function will animate a 3-1-3
% rotation using angles 45,30,60 in figure 1. These defaults will also be
% used in the place of null values.
% 
% Examples:  
%     %perform the standard 3-1-3 rotation in figure 2
%     animEuler(2);
%     %preform a 3-2-1 rotation of 30 degrees each
%     [coordSys,as] = animEuler([],[3,2,1],[30,30,30]);

% Written by Dmitry Savransky 29 April 2009

%if no inputs given
if ~exist('h','var') || isempty(h), h = 1; end
if ~exist('rotSet','var') || isempty(rotSet), rotSet = [3,1,3]; end
if ~exist('angs','var') || isempty(angs), angs = [45,30,60]; end

if length(rotSet) ~= 3 || length(angs) ~= 3
    error('rotSet and angs must be 3x1 arrays.');
end

%create axes and original orientation
as = make3daxes(h);
coordSys = eye(3);

%define rotation matrices
rotMatE3 = @(ang) [cos(ang) sin(ang) 0;-sin(ang) cos(ang) 0;0 0 1];
rotMatE2 = @(ang) [cos(ang) 0 -sin(ang);0 1 0;sin(ang) 0 cos(ang)];
rotMatE1 = @(ang) [1 0 0;0 cos(ang) sin(ang);0 -sin(ang) cos(ang)];
rotMats = {rotMatE1,rotMatE2,rotMatE3};

%perform rotations, pausing between each
axSyms = {'-','--','-.'};
for j=1:3
    rot3daxes(h,as,coordSys(rotSet(j),:),angs(j),axSyms{j});
    %update coordinate system
    coordSys = rotMats{rotSet(j)}(angs(j)*pi/180)*coordSys;
    if j~=3,pause(1);end
end