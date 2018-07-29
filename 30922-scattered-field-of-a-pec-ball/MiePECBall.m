function [Ex Ey Ez] = MiePECBall(cart, k, R, N)
% The code caculates the time-harmonic scattered field value at point 'cart' 
% due to a PEC ball with radius R centered at the origin. 
% The incident wave is E=exp(-ikz).
% The formulation is based on H.C. van de Hulst, P123
% 'light scattering by small particles', Dover, 1981
% Input: cart -- cartiesian coordiante (1x3) of the point ouside the ball
%        k    -- wavenumber
%        R    -- radius of the PEC ball
%        N    -- number of terms used in Mie series
% Output: [Ex Ey Ez] -- the scattering electric field
% Author: Jiguang Sun, 02/13/2011, jsun@desu.edu
% Please report bugs to jsun@desu.edu
% Copyright (c) 2011, Jiguang Sun, rights reserved. 
% THIS SOFTWARE IS PROVIDED "AS IS".
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted.
i = sqrt(-1); 
[phi,th,r] = cart2sph(cart(1), cart(2), cart(3)); th = pi/2-th;
if r < R
    % disp('The point is inside the ball!')
    Ex = 0; Ey = 0; Ez = 0;
    return;
end

n = 1:N+2; 
x = k*R; 
[j(n), ierr(1,n)] = besselj(n - 1 + 1/2, x); j = j*sqrt(pi/(2*x));
[h(n), ierr(1,n)] = besselh(n - 1 + 1/2, 2, x); h = h*sqrt(pi/(2*x));
if any(any(ierr))                
    disp('Accuracy error in a Bessel or Hankel function.');
    Ex = 0; Ey = 0; Ez = 0;
    return;
end
% scattering coefficients
an = j(2:N+1)./h(2:N+1);
bn = (j(2:N+1)+k*R*j(1:N)-k*R*j(3:N+2))./(h(2:N+1)+k*R*h(1:N)-k*R*h(3:N+2));
% various terms ralated to Racati-Bessel's functions
n = 1:N+4;
z = k*r; k2r = k^2*r;
[h(n), ierr(2,n)] = besselh(n - 2 + 1/2, 2, z); h = h*sqrt(pi/(2*z));
hn = h(3:N+2);
drh = (h(3:N+2)+k*r*h(2:N+1)-k*r*h(4:N+3))/2;
ddrh=(k2r*h(1:N)+2*k*h(2:N+1)-(1/r+2*k2r)*h(3:N+2)-2*k*h(4:N+3)+k2r*h(5:N+4))/4;
% 
if any(any(ierr))                
    disp('Accuracy error in a Bessel or Hankel function.')
    Ex = 0; Ey = 0; Ez = 0;
    return;
end
% various terms related to associated Legendre polynomials
Pn(1) = 1;
Pn(2) = cos(th);
for n=2:N-1
    Pn(n+1) = ((2*n-1)*cos(th)*Pn(n)-(n-1)*Pn(n-1))/n;
end
% Pn1 starts from n = 1.
Pn1(1) = -sin(th);
Pn1(2) = -3.0*sin(th)*cos(th);
for n=2:N-1
    Pn1(n+1) = (2.0*n+1)*cos(th)*Pn1(n)/n-(n+1)*Pn1(n-1)/n;
end
% Pn1S starts from n = 1;
Pn1S(1) = -1;
Pn1S(2) = -3.0*cos(th);
for n = 2:N-1
    Pn1S(n+1) = Pn1S(n-1)-(2*n+1)*Pn(n+1);
end

for n = 1:N
    if n == 1
        dPn1(n) = -cos(th);
    elseif n == 2
        dPn1(n) = 3*(2*sin(th)*sin(th)-1);
    else
        dPn1(n) = (2*n-1)/(n-1)*Pn1(n-1)*(-sin(th))+(2*n-1)/(n-1)*cos(th)*dPn1(n-1)-n/(n-1)*dPn1(n-2);
    end
end
% compute M and N
Mrho = 0; Mth = 0; Mphi = 0;
for n = 1:N
    c = (-i)^(n)*(2*n+1)/(n*(n+1));
    Mth = Mth + c*an(n)*hn(n)*Pn1S(n)*cos(phi);
    Mphi = Mphi-c*an(n)*hn(n)*dPn1(n)*sin(phi);
end
Nrho = 0; Nth = 0; Nphi = 0;
for n = 1:N
    c = (-i)^(n)*(2*n+1)/(n*(n+1));
    Nrho = Nrho + bn(n)*c*(ddrh(n)+k^2*r*hn(n))*Pn1(n)*cos(phi)/(k);
    Nth = Nth + bn(n)*c/r*drh(n)*dPn1(n)*cos(phi)/(k);
    Nphi = Nphi + bn(n)*c/r*drh(n)*Pn1S(n)*(-sin(phi))/(k);
end
% compute scattering field in Spherical coordinate
Erho = Mrho + i*Nrho;
Ephi = Mphi + i*Nphi;
Eth = Mth + i*Nth;
% change back to cartisian coordinate
Ex = Erho*sin(th)*cos(phi)+Eth*cos(th)*cos(phi)-Ephi*sin(phi);
Ey = Erho*sin(th)*sin(phi)+Eth*cos(th)*sin(phi)+Ephi*cos(phi);
Ez = Erho*cos(th)-Eth*sin(th);