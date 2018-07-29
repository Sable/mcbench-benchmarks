function [rInt,vInt] = Hill2ECI_Vectorized(rTgt,vTgt,rHill,vHill)
%% Purpose:
% Convert those position (rHill) and velocity (vHill) values back into an
% ECI coordinate frame of reference using the reference satellite
% (rTgt,vTgt) position and velocity data.
%
%% Inputs:
%rTgt                       [3 x N]                 ECI Position vector of
%                                                   reference frame (km)
%
%vTgt                       [3 x N]                 ECI Velocity vector of
%                                                   reference frame (km/s)
%
%rHill                      [3 x N]                 Hill's relative
%                                                   position vector (km)
%
%vHill                      [3 x N]                 Hill's relative
%                                                   velocity vector (km/s)
%
%
%
%% Outputs:
%rInt                       [3 x N]
%
%vInt                       [3 x N]
%
%
% References:
% Vallado 2007.
% Programed by Darin C Koblick 11/30/2012
%% Begin Code Sequence
%Declare Local Functions
rTgtMag = sqrt(sum(rTgt.^2,1));
vTgtMag = sqrt(sum(vTgt.^2,1));
matrixMultiply = @(x,y)permute(cat(2,sum(permute(x(1,:,:),[3 2 1]).*permute(y,[2 1]),2), ...
                                     sum(permute(x(2,:,:),[3 2 1]).*permute(y,[2 1]),2), ...
                                     sum(permute(x(3,:,:),[3 2 1]).*permute(y,[2 1]),2)),[2 1]);
%Find the RSW matrix from the target ECI positions
RSW = ECI2RSW(rTgt,vTgt); rIntMag = rTgtMag + rHill(1,:);
%Compute rotation angles to go from tgt to interceptor
lambda_int = rHill(2,:)./rTgtMag; phi_int = sin(rHill(3,:)./rTgtMag);
CLI = cos(lambda_int); SLI = sin(lambda_int); CPI = cos(phi_int); SPI = sin(phi_int);
%find rotation matrix to go from rsw to SEZ of inerceptor
RSW_SEZ = zeros(3,3,size(rTgt,2));
RSW_SEZ(1,1,:) = SPI.*CLI;  RSW_SEZ(1,2,:) = SPI.*SLI; RSW_SEZ(1,3,:) = -CPI;
RSW_SEZ(2,1,:) = -SLI;      RSW_SEZ(2,2,:) = CLI;      RSW_SEZ(3,1,:) = CPI.*CLI;
                            RSW_SEZ(3,2,:) = CPI.*SLI; RSW_SEZ(3,3,:) = SPI;
%Find velocity component positions by using angular rates in SEZ frame
vIntSEZ = cat(1,-rIntMag.*vHill(3,:)./rTgtMag, ...
                 rIntMag.*(vHill(2,:)./rTgtMag + vTgtMag./rTgtMag).*CPI, ...
                 vHill(1,:));
vInt = matrixMultiply(permute(RSW,[2 1 3]), ...
       matrixMultiply(permute(RSW_SEZ,[2 1 3]), ...
       vIntSEZ));
%Find the position components
rIntRSW = bsxfun(@times,rIntMag,cat(1,CPI.*CLI, ...
                                      CPI.*SLI, ...
                                      SPI));
rInt = matrixMultiply(permute(RSW,[2 1 3]),rIntRSW);      
end