function [X,Y,Z]=oblate0(eta,theta,psi)
% [X,Y,Z]=oblate0(eta,theta,psi) defines
% oblate spheroidal coordinates
X=cosh(eta).*sin(theta).*cos(psi);
Y=cosh(eta).*sin(theta).*sin(psi);
Z=sinh(eta).*cos(theta);