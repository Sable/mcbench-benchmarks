function [X,Y,Z]=toroid0(eta,theta,psi)
% [X,Y,Z]=toroid0(eta,theta,psi)
% This function defines toroidal coordinates using
% the formulas on page 112 of the 'Field Theory 
% Handbook' by P. Moon and D. E. Spencer
d=cosh(eta)-cos(theta); X=sinh(eta).*cos(psi)./d;
Y=sinh(eta).*sin(psi)./d; Z=sin(theta)./d;