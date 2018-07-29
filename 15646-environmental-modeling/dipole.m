function Phi = dipole (z,z0,S,Beta)
Phi = S*exp(i*Beta)./(2*pi*(z-z0));
