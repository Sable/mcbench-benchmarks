function [q, M] = conversionMatrix2Quaternion(M, varargin)
% conversionMatrix2Quaternion - function to convert Rotation Matrix to Quaternion coeff
%
% Syntax:  q = conversionMatrix2Quaternion(M(3,3))
%          q = conversionMatrix2Quaternion(M(1,1),M(1,2),M(1,3),M(2,1),M(2,2),M(2,3),M(3,1),M(3,2),M(3,3))
%          q = conversionMatrix2Quaternion([theta, psi, phi])
%          q = conversionMatrix2Quaternion(theta, psi, phi)
%
% Inputs:
%          M - Rotation Matrix (3,3)
%     *theta - X rotation angle (deg)
%       *psi - Y rotation angle (deg)
%       *phi - Z rotation angle (deg)
%
% Outputs:
%     q - quaternion values [q0 qx qy qz]
%     M - Rotation Matrix used to compute q
%
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none;

% Author: Marco Borges, Ph.D. Student, Computer/Biomedical Engineer
% UFMG, PPGEE, Neurodinamica Lab, Brazil
% email address: marcoafborges@gmail.com
% Website: http://www.cpdee.ufmg.br/
% Reference: http://www.euclideanspace.com/maths/geometry/rotations/conversions/matrixToQuaternion/
% April 2013; v2; Last revision: 2013-04-18
% Changelog: v2 - add linear velocity extraction

%------------- BEGIN CODE --------------
% M = [m00 m01 m02;
%     m10 m11 m12;
%     m20 m21 m22];

if length(M) == 1 && nargin == 8
    M = [M, varargin{1}, varargin{2}; varargin{3}, varargin{4}, varargin{5}; varargin{6}, varargin{7}, varargin{8}];
    
elseif length(M) == 9
    M = [M(1), M(2), M(3); M(4), M(5), M(6); M(7), M(8), M(9)];
    
elseif length(M) == 3 % [theta (x rot), psi (y rot), phi (z rot)]
    theta = M(1); psi = M(2); phi = M(3);
    M = [cos(deg2rad(psi))*cos(deg2rad(phi)), cos(deg2rad(psi))*sin(deg2rad(phi)), -sin(deg2rad(psi));
         (-cos(deg2rad(theta))*sin(deg2rad(phi)))+(sin(deg2rad(theta))*sin(deg2rad(psi))*cos(deg2rad(phi))), (cos(deg2rad(theta))*cos(deg2rad(phi)))+(sin(deg2rad(theta))*sin(deg2rad(psi))*sin(deg2rad(phi))), sin(deg2rad(theta))*cos(deg2rad(psi));
         (sin(deg2rad(theta))*sin(deg2rad(phi)))+(cos(deg2rad(theta))*sin(deg2rad(psi))*cos(deg2rad(phi))), (-sin(deg2rad(theta))*cos(deg2rad(phi)))+(cos(deg2rad(theta))*sin(deg2rad(psi))*sin(deg2rad(phi))), cos(deg2rad(theta))*cos(deg2rad(psi))];

elseif length(M) == 1 && nargin == 3 % (theta (x rot), psi (y rot), phi (z rot))
    theta = M; psi = varargin{1}; phi = varargin{2};
    M = [cos(deg2rad(psi))*cos(deg2rad(phi)), cos(deg2rad(psi))*sin(deg2rad(phi)), -sin(deg2rad(psi));
         (-cos(deg2rad(theta))*sin(deg2rad(phi)))+(sin(deg2rad(theta))*sin(deg2rad(psi))*cos(deg2rad(phi))), (cos(deg2rad(theta))*cos(deg2rad(phi)))+(sin(deg2rad(theta))*sin(deg2rad(psi))*sin(deg2rad(phi))), sin(deg2rad(theta))*cos(deg2rad(psi));
         (sin(deg2rad(theta))*sin(deg2rad(phi)))+(cos(deg2rad(theta))*sin(deg2rad(psi))*cos(deg2rad(phi))), (-sin(deg2rad(theta))*cos(deg2rad(phi)))+(cos(deg2rad(theta))*sin(deg2rad(psi))*sin(deg2rad(phi))), cos(deg2rad(theta))*cos(deg2rad(psi))];
end
    

tr = M(1,1) + M(2,2) + M(3,3);

if (tr > 0)
    S = sqrt(tr+1.0) * 2; % S=4*qw
    qw = 0.25 * S;
    qx = (M(3,2) - M(2,3)) / S;
    qy = (M(1,3) - M(3,1)) / S;
    qz = (M(2,1) - M(1,2)) / S;
elseif ((M(1,1) > M(2,2)) && (M(1,1) > M(3,3)))
    S = sqrt(1.0 + M(1,1) - M(2,2) - M(3,3)) * 2; % S=4*qx
    qw = (M(3,2) - M(2,3)) / S;
    qx = 0.25 * S;
    qy = (M(1,2) + M(2,1)) / S;
    qz = (M(1,3) + M(3,1)) / S;
elseif (M(2,2) > M(3,3))
    S = sqrt(1.0 + M(2,2) - M(1,1) - M(3,3)) * 2; % S=4*qy
    qw = (M(1,3) - M(3,1)) / S;
    qx = (M(1,2) + M(2,1)) / S;
    qy = 0.25 * S;
    qz = (M(2,3) + M(3,2)) / S;
else
    S = sqrt(1.0 + M(3,3) - M(1,1) - M(2,2)) * 2; % S=4*qz
    qw = (M(2,1) - M(1,2)) / S;
    qx = (M(1,3) + M(3,1)) / S;
    qy = (M(2,3) + M(3,2)) / S;
    qz = 0.25 * S;
end

q = [qw qx qy qz];
%-------------- END CODE ---------------