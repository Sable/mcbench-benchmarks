%----------------------- Begin Code Sequence -----------------------------%
% Purpose:                                                                %
% Convert WGS 84 (CTS, ECEF) Coordinates to ECI (CIS, Epoch J2000.0)      %
% Coordinates. This function has been vectorized for speed.               %
%                                                                         %
% Inputs:                                                                 %
%-------                                                                  %
%JD                     [1 x N]                         Julian Date Vector
%
%r_ECEF                 [3 x N]                         Position Vector
%                                                       in ECEF coordinate
%                                                       frame of reference
%
%v_ECEF                 [3 x N]                         Velocity Vector in
%                                                       ECEF coordinate
%                                                       frame of reference
%
%a_ECEF                 [3 x N]                         Acceleration Vector
%                                                       in ECEF coordinate
%                                                       frame of reference
%

%
% Outputs:
%---------                                                                %
%r_ECI                  [3 x N]                         Position Vector in
%                                                       ECI coordinate
%                                                       frame of reference
%
%v_ECI                  [3 x N]                         Velocity vector in
%                                                       ECI coordinate
%                                                       frame of reference
%
%a_ECI                  [3 x N]                         Acceleration Vector
%                                                       in ECI coordinate
%                                                       frame of reference
%
% References:
%-------------
%Orbital Mechanics with Numerit, http://www.cdeagle.com/omnum/pdf/csystems.pdf
%
%
% Function Dependencies:
%------------------
% JD2GMST
%------------------------------------------------------------------       %
% Programed by Darin Koblick  07-17-2010                                  %
% Modified on 03/01/2012 to add acceleration vector support               %
%------------------------------------------------------------------       %
function [r_ECI v_ECI a_ECI] = ECEFtoECI(JD,r_ECEF,v_ECEF,a_ECEF)
%Enforce JD to be [N x 1]
JD = JD(:);

%Calculate the Greenwich Apparent Sideral Time (THETA)
%See http://www.cdeagle.com/omnum/pdf/csystems.pdf equation 27
THETA = JD2GAST(JD);

%Average inertial rotation rate of the earth radians per second
omega_e = 7.29211585275553e-005;

%Assemble the transformation matricies to go from ECEF to ECI
%See http://www.cdeagle.com/omnum/pdf/csystems.pdf equation 26
r_ECI = squeeze(MultiDimMatrixMultiply(MultiDimMatrixTranspose(T3D(THETA)),r_ECEF));
v_ECI = squeeze(MultiDimMatrixMultiply(MultiDimMatrixTranspose(T3D(THETA)),v_ECEF) + ...
    MultiDimMatrixMultiply(MultiDimMatrixTranspose(Tdot3D(THETA,omega_e)),r_ECEF));
a_ECI = squeeze(MultiDimMatrixMultiply(MultiDimMatrixTranspose(T3D(THETA)),a_ECEF) + ...
    2.*MultiDimMatrixMultiply(MultiDimMatrixTranspose(Tdot3D(THETA,omega_e)),v_ECEF) + ...
    MultiDimMatrixMultiply(MultiDimMatrixTranspose(Tddot3D(THETA,omega_e)),r_ECEF));
%----------------------------- End Code-----------------------------------%

function C = MultiDimMatrixMultiply(A,B)
C = sum(bsxfun(@times,A,repmat(permute(B',[3 2 1]),[size(A,2) 1 1])),2);

function A = MultiDimMatrixTranspose(A)
A = permute(A,[2 1 3]);

function T = T3D(THETA)
T = zeros([3 3 length(THETA)]);
T(1,1,:) = cosd(THETA);
T(1,2,:) = sind(THETA);
T(2,1,:) = -T(1,2,:);
T(2,2,:) = T(1,1,:);
T(3,3,:) = ones(size(THETA));

function Tdot = Tdot3D(THETA,omega_e)
Tdot = zeros([3 3 length(THETA)]);
Tdot(1,1,:) = -omega_e.*sind(THETA);
Tdot(1,2,:) = omega_e.*cosd(THETA);
Tdot(2,1,:) = -Tdot(1,2,:);
Tdot(2,2,:) = Tdot(1,1,:);

function Tddot = Tddot3D(THETA,omega_e)
Tddot = zeros([3 3 length(THETA)]);
Tddot(1,1,:) = -(omega_e.^2).*cosd(THETA);
Tddot(1,2,:) = -(omega_e.^2).*sind(THETA);
Tddot(2,1,:) = -Tddot(1,2,:);
Tddot(2,2,:) =  Tddot(1,1,:);


    
    