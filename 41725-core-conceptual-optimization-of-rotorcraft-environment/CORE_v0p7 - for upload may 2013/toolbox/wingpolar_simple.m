function [CD CLmax CDv qratio]= wingpolar(CL,AC,tState)
% inputs:
%   AC: see documentation
%   tState: see documentation
%   CL: wing lift coefficient; L = CL*q*Sref_wing
% outputs:
%   CD: wing drag coefficient; D = CD*q*Sref_wing
%   CLmax: WING maximum lift coefficient
%   CDv: drag coefficient of the wing due to the vertical downwash
%   qratio: ratio of downwash q at wing to 1/2*rho*(v_induced)^2

if AC.Wing.S
    e = .9;
    CD0 = .009;
    CD = CD0 + CL.^2./(pi*e*AC.Wing.AR);
else
    CD = .009;
end

if nargout >1
CLmax = 1.2; %this could be improved by adjusting CLmax to the AR
CDv = 1.3; %drag coefficient of the wing to the vertical downwash
qratio = .6; %ratio of downwash q at wing to 1/2*rho*(v_induced)^2
end