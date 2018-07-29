function [T,rRSW,vRSW] = ECI2RSW(rECI,vECI)
%% Purpose:
%Convert ECI Coordinates to RSW Coordinates, also, return the
%transformation matrix T in which to take a given set of coordinates in ECI
%and convert them using the same RSW reference frame.
%
%% Inputs:
% rECI              [3 x N]                     ECI position Coordinates in
%                                               km
%
% vECI              [3 x N]                     ECI velocity Coordinates in
%                                               km/s
%
%% Outputs:
% T                 [3 x 3 x N]                 Transformation matrix
%                                               necessary to go from
%                                               rECI -> rRSW
%
% rRSW              [3 x N]                     RSW Position Coordinates
%                                               km
%
% vRSW              [3 x N]                     RSW Velocity Coordinates
%                                               km/s
%
%% References:
% Vallado pg. 173
% Vallado rv2rsw.m code dated 06/09/2002
%
%Programmed by: Darin C Koblick                 11/29/2012
%% Begin Code Sequence
if nargin == 0
    rECI =  repmat([6968.1363,1,2]',[1 10]);
    vECI =  repmat([3,7.90536615282099,4]',[1 10]);
    [T,rRSW,vRSW] = ECI2RSW(rECI,vECI);
    return;
end
%Declared Internal function set:
unitv = @(x)bsxfun(@rdivide,x,sqrt(sum(x.^2,1)));
matrixMultiply = @(x,y)permute(cat(2,sum(permute(x(1,:,:),[3 2 1]).*permute(y,[2 1]),2), ...
                                     sum(permute(x(2,:,:),[3 2 1]).*permute(y,[2 1]),2), ...
                                     sum(permute(x(3,:,:),[3 2 1]).*permute(y,[2 1]),2)),[2 1]);
%Find the Radial component of the RIC position vector
rvec = unitv(rECI);
%Find the cross-track component of the RIC position vector
wvec = unitv(cross(rECI,vECI));
%Find the along-track component of the RIC position vector
svec = unitv(cross(wvec,rvec));
%Create the transformation matrix from ECI to RSW
T = NaN(3,3,size(rECI,2));
T(1,1,:) = rvec(1,:); T(1,2,:) = rvec(2,:); T(1,3,:) = rvec(3,:);
T(2,1,:) = svec(1,:); T(2,2,:) = svec(2,:); T(2,3,:) = svec(3,:);
T(3,1,:) = wvec(1,:); T(3,2,:) = wvec(2,:); T(3,3,:) = wvec(3,:);
%Find the position and velocity vectors in the RSW reference frame!
rRSW = matrixMultiply(T,rECI);
vRSW = matrixMultiply(T,vECI);
end

