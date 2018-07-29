function rotvec=SHRotateVec(vec,alp,bta,gam)

% rotvec=SHRotateVec(vec,alp,bta,gam)
%
% Rotates spherical harmonics by rearranging their
% coefficients after computing the rotation matrix.
% Uses the function plm2rot from DOTM library,
% by F. J. Simons.
%
% INPUT:
%
% vec              Vector of real spherical harmonic coefficients
% alp, bta, gam    Three Euler angles, in degrees
%                  alp (0<2pi): rotates around z increasing from x to y
%                  bta (0<pi):  rotates around new y increasing from z to x
%                  gam (0<2pi): rotates around old z increasing from x to y
% 
% Alternative usage: SHRotateVec(vec,'GG') to rotate to geographic coords;
%                    SHRotateVec(vec,'GM') to rotate to geomagnetic coords.
%
% OUTPUT:
%
% rotvec           Vector of real spherical harmonic coefficients rotated
%
% NOTE:
%
% Find the appropriate rotation angles for simple geographic location
% alpha=0;     % Around z axis
% beta=90-lat; % To a desired colatitude
% gamma=lon;   % To a desired longitude
% 
% Copyright: Anna Kelbert, 21 Mar 2007

if nargin < 2
    error('Please specify rotation angles or required coordinate system')
end

if ischar(alp)
    coords = alp;
    switch coords
        case 'GG'
            disp('Rotating from GM to GG coordinates')
            alp=0; bta=11; gam=290;
        case 'GM'
            disp('Rotating from GG to GM coordinates')
            alp=-290; bta=-11; gam=0;
        otherwise
            error('Unknown coordinate system')
    end
else
    if nargin < 4
        error('Please specify valid rotation angles')
    end
end

lmcosi = SHVec2lmcosi(vec);
lmcosip = plm2rot(lmcosi,alp,bta,gam,'dlmb');
rotvec = SHlmcosi2Vec(lmcosip);