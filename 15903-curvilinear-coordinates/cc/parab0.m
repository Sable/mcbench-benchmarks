function [X,Y,Z]=parab0(mu,nu,psi)
% [X,Y,Z]=parab0(mu,nu,psi) defines
% parabolic coordinates
X=mu.*nu.*cos(psi); Y=mu.*nu.*sin(psi);
Z=(mu.^2-nu.^2)/2;