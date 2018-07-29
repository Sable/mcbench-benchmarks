function [r,v] = keplerUniversal(r0,v0,t,mu)
%Purpose:
%Most effecient way to propagate any type of two body orbit using kepler's
%equations.
%-------------------------------------------------------------------------%
%                                                                         %
% Inputs:                                                                 %
%--------                                                                  
%r_ECI                  [3 x N]                         Position Vector in
%                                                       ECI coordinate
%                                                       frame of reference
%
%v_ECI                  [3 x N]                         Velocity vector in
%                                                       ECI coordinate
%                                                       frame of reference
%
%t                      [1 x N]                         time vector in
%                                                       seconds
%
%mu                     double                          Gravitational Constant
%                                                       Defaults to Earth if
%                                                       not specified
% Outputs:
%---------                                                                %
%r_ECI                  [3 x N]                         Final position
%                                                       vector in ECI
%
%v_ECI                  [3 x N]                         Final velocity
%                                                       vector in ECI
%--------------------------------------------------------------------------
% Programmed by Darin Koblick 03-04-2012                                  %
%-------------------------------------------------------------------------- 
if ~exist('mu','var'); mu = 398600.4418; end
tol = 1e-8;
v0Mag = sqrt(sum(v0.^2,1));  r0Mag = sqrt(sum(r0.^2,1));
alpha = -(v0Mag.^2)./mu + 2./r0Mag; 
%% Compute initial guess (X0) for Newton's Method
X0 = NaN(size(t));
%Check if there are any Eliptic/Circular orbits
idx = alpha > 0.000001;
if any(idx)
    X0(idx) = sqrt(mu).*t(idx).*alpha(idx); 
end
%Check if there are any Parabolic orbits
idx = abs(alpha) < 0.000001;
if any(idx)
   h = cross(r0(:,idx),v0(:,idx)); hMag = sqrt(sum(h.^2,1));
   p = (hMag.^2)./mu; s = acot(3.*sqrt(mu./(p.^3)).*t(idx))./2;
   w = atan(tan(s).^(1/3)); X0(idx) = sqrt(p).*2.*cot(2.*w);
end
%Check if there are any Hyperbolic orbits
idx = alpha < -0.000001;
if any(idx)
   a = 1./alpha(idx);
   X0(idx) = sign(t(idx)).*sqrt(-a).*...
       log(-2.*mu.*alpha(idx).*t(idx)./ ...
       (dot(r0(:,idx),v0(:,idx))+sign(t(idx)).*sqrt(-mu.*a).*...
       (1-r0Mag(idx).*alpha(idx))));
end
%% Newton's Method to converge on solution
% Declare Constants that do not need to be computed within the while loop
err = Inf;
dr0v0Smu = dot(r0,v0)./sqrt(mu);
Smut = sqrt(mu).*t;
while any(abs(err) > tol)
    X02 = X0.^2;
    X03 = X02.*X0;
    psi = X02.*alpha;
    [c2,c3] = c2c3(psi);
    X0tOmPsiC3 = X0.*(1-psi.*c3);
    X02tC2 = X02.*c2;
    r = X02tC2 + dr0v0Smu.*X0tOmPsiC3 + r0Mag.*(1-psi.*c2);
    Xn = X0 + (Smut-X03.*c3-dr0v0Smu.*X02tC2-r0Mag.*X0tOmPsiC3)./r;
    err = Xn-X0; X0 = Xn;
end
f = 1 - (Xn.^2).*c2./r0Mag; g = t - (Xn.^3).*c3./sqrt(mu);
gdot = 1 - c2.*(Xn.^2)./r; fdot = Xn.*(psi.*c3-1).*sqrt(mu)./(r.*r0Mag);
r = bsxfun(@times,f,r0) + bsxfun(@times,g,v0);
v = bsxfun(@times,fdot,r0) + bsxfun(@times,gdot,v0);
%% Ensure Solution Integrity
%idx = round((f.*gdot - fdot.*g)./tol).*tol ~= 1; r(:,idx) = NaN; v(:,idx) = NaN;
end

function [c2,c3] = c2c3(psi)
%Vallado pg. 71 Algorithm 1
c2 = NaN(size(psi));
c3 = NaN(size(psi));
idx = psi > 1e-6;
if any(idx)
    c2(idx) = (1-cos(sqrt(psi(idx))))./psi(idx);
    c3(idx) = (sqrt(psi(idx))-sin(sqrt(psi(idx))))./sqrt(psi(idx).^3);
end
idx = psi < -1e-6;
if any(idx)
    c2(idx) = (1 - cosh(sqrt(-psi(idx))))./psi(idx);
    c3(idx) = (sinh(sqrt(-psi(idx)))-sqrt(-psi(idx)))./sqrt(-psi(idx).^3);
end
idx = abs(psi) <= 1e-6;
if any(idx)
    c2(idx) = 0.5;
    c3(idx) = 1/6;
end
end