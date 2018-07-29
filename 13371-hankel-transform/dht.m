%[H,k,r,I,K,R,h]=dht(h,R;R,N;K,n;I)
%----------------------------------
%
%Quasi-discrete Hankel transform of integer order n.
%
%This implementation uses an array of Bessel roots, which
%is stored in 'dht.mat'. By default, the first 4097 roots
%of the Bessel functions of the first kind with order 0 to
%4 were precomputed. This allows DHT up to an order of 4
%with up to 4096 sampling points by default. Use JNROOTS
%for calculating more roots.
%
%Input:
% h      Function h(r)
%   or
% h      Signal h(r) *
% R      Maximum radius [m]
%   or
% R      Signal factors °                 {default}
% N      Number of sampling points        {256}
%   or
% K      Spectrum factors °               {default}
% n      Transform order                  {0}
%   or
% I      Integration kernel °             {default}
%
%Output:
% H      Spectrum H(k)
% k      Spatial frequencies [rad/m]
% r      Radial positions [m]
% I      Integration kernel
% K      Spectrum factors
% R      Signal factors
% h      Signal h(r)
%
%
% *)  Values request the presence of the kernel, samplings
%     and factors, which can be computed with empty input.
%
% °)  The computation of the integration kernel is slow com-
%     pared to the full transform. But if the factors and the
%     kernel are all present, they are reused as is.
%

% [1] M. Guizar-Sicairos, J.C. Gutierrez-Vega, Computation of
%     quasi-discrete Hankel transforms of integer order for
%     propagating optical wave fields, J. Opt. Soc. Am. A 21,
%     53-58 (2004).
%

%     Marcel Leutenegger © June 2006
%     Manuel Guizar-Sicairos © 2004
%
function [H,k,r,I,K,R,h]=dht(h,R,N,n)
if nargin < 3 | isempty(N)
   N=256;
end
if nargin < 4 | isempty(n)
   n=0;
end
if numel(n) > 1
   K=N;
   I=n;
else
   if ~isempty(h) & isa(h,'numeric')
      error('Need a function h(r) without kernel.');
   end
   load('dht.mat');                 % Bessel Jn rooths
   C=c(1+n,1+N);
   c=c(1+n,1:N);
   r=R/C*c(:);
   k=c(:)/R;
   I=abs(besselj(1+n,c));
   K=2*pi*R/C*I(:);
   R=I(:)/R;
   I=sqrt(2/C)./I;
   I=I(:)*I.*besselj(n,c(:)/C*c);
end
if isempty(h)
   H=h;
else
   if ~isa(h,'numeric')
      h=feval(h,r);
   end
   H=I*(h./R).*K;
end
