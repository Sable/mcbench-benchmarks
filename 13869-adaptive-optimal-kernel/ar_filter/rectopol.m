function [req, pheq] = rectopol(nraf, nlag, nrad, nphi)
% rectopol: find polar indices corresponding to rect samples
% G.A. Reina 16 Jan 2007
% Modified from the C code provided by D. L. Jones and R. G. Baraniuk
% "An Adaptive Optimal-Kernel Time-Frequency Representation"
%   by D. L. Jones and R. G. Baraniuk, IEEE Transactions on Signal 
%   Processing, Vol. 43, No. 10, pp. 2361--2371, October 1995.

deltau = sqrt(pi/(nlag-1));
deltheta = 2*sqrt((nlag-1)*pi)/nraf;
delrad = sqrt(2*pi*(nlag-1))/nrad;
delphi = pi/nphi;

half_nraf = floor(nraf / 2);

req = zeros(nraf, nlag);
pheq = zeros(nraf, nlag);

for jj = 0:(half_nraf-1),

    req(jj+1, :) = sqrt(((0:(nlag-1))*deltau).^2 + (jj*deltheta).^2) / delrad;
    pheq(jj+1, 2:end) = (atan((jj*deltheta)./((1:(nlag-1))*deltau)) + pi/2)/delphi;
   
    jt = jj - half_nraf;
    req(jj+1+half_nraf, :) = sqrt( ((0:(nlag-1))*deltau).^2 + (jt*deltheta).^2) / delrad;
    pheq(jj+1+half_nraf, 2:end) = (atan((jt*deltheta)./((1:(nlag-1))*deltau)) + pi/2) / delphi;


end









