%h=ifht(H,k,r,n;I)
%-----------------
%
%Inverse fast Hankel transform of order n.
%
%Input:
% H      Spectrum H(k)
% k      Spatial frequencies [rad/m] °
% r      Radial positions [m] °
% n      Transform order               {0}
%   or
% I      Integration kernel °*         {default}
%
%Output:
% h      Signal h(r)
%
%
% °)  As computed with FHT.
%
% *)  If the integration kernel is missing, it is
%     recomputed from the Bessel functions (slow).
%

% [1] A.E. Siegmann, Quasi fast Hankel transform,
%     Opt. Lett. 1, 13-15 (1977).
%

%     Marcel Leutenegger © June 2006
%
function h=ifht(H,k,r,n)
N=numel(k);
if nargin < 4 | isempty(n)
   n=0;
end
if numel(n) > 1
   I=n;
else
   a=log(k(end)/k(1))/(N-1);
   I=[k k(end)*exp(a*(1:N))];
   I=ifft(a*r(1)*I.*besselj(n,r(1)*I));
end
h=fft(fft(H.*k,2*N).*I);
if isreal(H)
   h=real(h);
end
h=h(1:N)./(2*pi*r);
