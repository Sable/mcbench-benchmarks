function H=MDexact(M,x0,y0,z0,x,y,z,er,mr,sigma,f)
%
% function H=MDexact(M,x0,y0,z0,x,y,z,er,mr,sigma,f)
%
% Function MDEXACT calculates the magnetic field in position (x,y,z) for a
% impulsive source M=I*Am placed in the point (x0,y0,z0). The source is
% inserted in a medium characterized by dielectric permettivity er,
% magnetic permeability mr and conductivity sigma. The temporal rule is
% exp(-i*omega*t).
%
% INPUT
%   M = M*l, impulsive value of the magnetic dipole [A*m^2]
%   x0,y0,z0 = coordinates of the dipole [m]
%   x,y,z = point where the field is calculated [m]
%   er = relative dialectric permettivity
%   mr = relative magnetic permeability
%   sigma = conductivity [S/m]
%   f = frequency [Hz]
%
% OUTPUT
%   H(1:3,1) = Hx, Hy and Hz with dipole directed along x
%   H(1:3,2) = Hx, Hy and Hz with dipole directed along y
%   H(1:3,3) = Hx, Hy and Hz with dipole directed along z

% change the reference system (index 0 refers to the system in which the
% dipole is placed in the origin): the script was originally written for a
% dipole placed in (0,0,0).
x=x-x0;
y=y-y0;
z=z-z0;

% constant
v0=2.997925e8;
mu0=pi*4e-7;
eps0=1/(v0^2*mu0);
eps=eps0*er;
mu=mu0*mr;
omega=2*pi*f;
gammaq=j*omega*mu.*(sigma+j*omega*eps);
gamma=sqrt(gammaq);

H=zeros(3,3);

% dipole along x
rho=sqrt(y^2+z^2);
r=sqrt(rho^2+x^2);
if rho<1e-10,
    cosphi=1;
    sinphi=0;
else
    cosphi=z/rho;
    sinphi=-y/rho;
end
costheta=x/r;
sintheta=sqrt(1-costheta^2);

Hr_exact=-j*(M/(2*pi*omega*mu*r^3))*(1+gamma*r).*exp(-gamma*r)*costheta;
Htheta_exact=-j*(M/(4*pi*omega*mu*r^3))*(1+gamma*r+gamma.^2*r^2).*exp(-gamma*r)*sintheta;
Hrho_exact=Hr_exact*sintheta+Htheta_exact*costheta;

Hx_exact=Hr_exact*costheta-Htheta_exact*sintheta;
Hz_exact=Hrho_exact*cosphi;
Hy_exact=-Hrho_exact*sinphi;

H(1,1)=Hx_exact;
H(2,1)=Hy_exact;
H(3,1)=Hz_exact;

% dipole along y
rho=sqrt(x^2+z^2);
r=sqrt(rho^2+y^2);
if rho<1e-10,
    cosphi=1;
    sinphi=0;
else
    cosphi=x/rho;
    sinphi=z/rho;
end
costheta=y/r;
sintheta=sqrt(1-costheta^2);

Hr_exact=(M/(2*pi*r^3))*(1+gamma*r).*exp(-gamma*r)*costheta;
Htheta_exact=(M/(4*pi*r^3))*(1+gamma*r+gamma.^2*r^2).*exp(-gamma*r)*sintheta;
Hrho_exact=Hr_exact*sintheta+Htheta_exact*costheta;

Hy_exact=Hr_exact*costheta-Htheta_exact*sintheta;
Hx_exact=Hrho_exact*cosphi;
Hz_exact=Hrho_exact*sinphi;

H(1,2)=Hx_exact;
H(2,2)=Hy_exact;
H(3,2)=Hz_exact;

% dipole along z
rho=sqrt(x^2+y^2);
r=sqrt(rho^2+z^2);
if rho<1e-10,
    cosphi=1;
    sinphi=0;
else
    cosphi= x/rho;
    sinphi= y/rho;
end
costheta=z/r;
sintheta=sqrt(1-costheta^2);

Hr_exact=(M/(2*pi*r^3))*(1+gamma*r).*exp(-gamma*r)*costheta;
Htheta_exact=(M/(4*pi*r^3))*(1+gamma*r+gamma.^2*r^2).*exp(-gamma*r)*sintheta;
Hrho_exact=Hr_exact*sintheta+Htheta_exact*costheta;

Hz_exact=Hr_exact*costheta-Htheta_exact*sintheta;
Hx_exact=Hrho_exact*cosphi;
Hy_exact=Hrho_exact*sinphi;

H(1,3)=Hx_exact;
H(2,3)=Hy_exact;
H(3,3)=Hz_exact;

% switch to exp(-i*omega*t)
H = conj(H);
