function [X,Y,Z]=elipcyl0(eta,psi,z)
% [x,y,z]=elipcyl0(eta,psi,z) defines
% elliptic cylinder coordinates
X=cosh(eta).*cos(psi); Y=sinh(eta).*sin(psi);
Z=z;