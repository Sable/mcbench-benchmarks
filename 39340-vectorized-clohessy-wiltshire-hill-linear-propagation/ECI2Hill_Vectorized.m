function [rHill,vHill] = ECI2Hill_Vectorized(rTgt,vTgt,rChase,vChase)
%% Purpose:
% Convert those position (ECI) and velocity (ECI) into Hill's reference
% frame using both the target and the chaser position/velocity data
%
%% Inputs:
%rTgt                       [3 x N]                 ECI Position vector of
%                                                   reference frame (km)
%
%vTgt                       [3 x N]                 ECI Velocity vector of
%                                                   reference frame (km/s)
%rChase                     [3 x N]
%
%vChase                     [3 x N]
%
%% Outputs:
%rHill                      [3 x N]                 Hill's relative
%                                                   position vector (km)
%
%vHill                      [3 x N]                 Hill's relative
%                                                   velocity vector (km/s)
% References:
% Vallado 2007.
% Programed by Darin C Koblick 11/30/2012
%% Begin Code Sequence
%Declare Local Functions
matrixMultiply = @(x,y)permute(cat(2,sum(permute(x(1,:,:),[3 2 1]).*permute(y,[2 1]),2), ...
                                     sum(permute(x(2,:,:),[3 2 1]).*permute(y,[2 1]),2), ...
                                     sum(permute(x(3,:,:),[3 2 1]).*permute(y,[2 1]),2)),[2 1]);
rTgtMag = sqrt(sum(rTgt.^2,1));
rChaseMag = sqrt(sum(rChase.^2,1));
vTgtMag = sqrt(sum(vTgt.^2,1));
%Determine the RSW transformation matrix from the target frame of reference
RSW = ECI2RSW(rTgt,vTgt);
%Use RSW rotation matrix to convert rChase and vChase to RSW
r_Chase_RSW = matrixMultiply(RSW,rChase);
v_Chase_RSW = matrixMultiply(RSW,vChase);
%Find Rotation angles to go from target to interceptor
phi_chase = asin(r_Chase_RSW(3,:)./rChaseMag);
lambda_chase = atan2(r_Chase_RSW(2,:),r_Chase_RSW(1,:));
CPC = cos(phi_chase);     SPC = sin(phi_chase);
SLC = sin(lambda_chase);  CLC = cos(lambda_chase);
%Find Position component rotations
rHill = cat(1,rChaseMag-rTgtMag, ...
              lambda_chase.*rTgtMag, ...
              phi_chase.*rTgtMag);
%Find the rotation matrix RSW->SEZ of chaser
RSW_SEZ = zeros(3,3,size(rTgtMag,2));
RSW_SEZ(1,1,:) = SPC.*CLC;  RSW_SEZ(1,2,:) = SPC.*SLC;  RSW_SEZ(1,3,:) = -CPC;
RSW_SEZ(2,1,:) = -SLC;  RSW_SEZ(2,2,:) = CLC;
RSW_SEZ(3,1,:) = CPC.*CLC;  RSW_SEZ(3,2,:) = CPC.*SLC;  RSW_SEZ(3,3,:) = SPC;
%Find the velocity component of positions using the angular rates in SEZ frame
v_Chase_SEZ = matrixMultiply(RSW_SEZ,v_Chase_RSW);
vHill = cat(1,v_Chase_SEZ(3,:), ...
              rTgtMag.*(v_Chase_SEZ(2,:)./(rChaseMag.*CPC)-vTgtMag./rTgtMag), ...
              -rTgtMag.*v_Chase_SEZ(1,:)./rChaseMag);
end