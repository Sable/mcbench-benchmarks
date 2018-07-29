function [M,Rot] = GetTransformMatrix(info1, info2)
% This function calculates the 4x4 transform and 3x3 rotation matrix 
% between two image coordinate system. 
% M=Tipp*R*S*T0;
% Tipp:translation
% R:rotation
% S:pixel spacing
% T0:translate to center(0,0,0) if necessary
% info1: dicominfo of 1st coordinate system
% info2: dicominfo of 2nd coordinate system
% Rot: rotation matrix between coordinate system
% Coded by Alper Yaman, Feb 2009

[Mtf,Rtf] = TransMatrix(info1);
[Mdti,Rdti] = TransMatrix(info2);
M = inv(Mdti) * Mtf;
Rot = inv(Rdti) * Rtf;
end


function [M,R] = TransMatrix(info)
%This function calculates the 4x4 transform matrix from the image
%coordinates to patient coordinates. 
ipp=info.ImagePositionPatient;
iop=info.ImageOrientationPatient;
ps=info.PixelSpacing;
Tipp=[1 0 0 ipp(1); 0 1 0 ipp(2); 0 0 1 ipp(3); 0 0 0 1];
r=iop(1:3);  c=iop(4:6); s=cross(r',c');
R = [r(1) c(1) s(1) 0; r(2) c(2) s(2) 0; r(3) c(3) s(3) 0; 0 0 0 1];
if info.MRAcquisitionType=='3D' % 3D turboflash
    S = [ps(2) 0 0 0; 0 ps(1) 0 0; 0 0 info.SliceThickness 0 ; 0 0 0 1];
else % 2D epi dti
    S = [ps(2) 0 0 0;0 ps(1) 0 0;0 0 info.SpacingBetweenSlices 0;0 0 0 1];
end
T0 = [ 1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
M = Tipp * R * S * T0;
end