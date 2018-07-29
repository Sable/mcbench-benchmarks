%fkn_gauss - A modified Gaussian function.
%   [y,beta]=fkn_gauss(p,r,R,Isum,Isum0) where:
%
%   y = beta*(1-p(1)*exp(-r.^2/p(2)^2))
%   beta = Isum/(Isum0+p(1)*pi*p(2)^2*exp(-R^2/p(2)^2))
%
%   p(1) = A (the amplitude of the Gaussian)
%   p(2) = w (the width of the Gaussian)
%   r = radial distances
%   Isum = the intensity at the current frame
%   Isum0 = the intensity at the first post-bleach frame
%   Ir0 = Ir(R,0) (the radial intensity at the edge of the field of view) 

function [y,beta]=fkn_gauss(p,r,Isum,Isum0,Ir0)
R=max(r);
beta=Isum/(Isum0/Ir0+p(1)*pi*p(2)^2*exp(-R^2/p(2)^2));
y=beta*(1-p(1)*exp(-r.^2/p(2)^2));

