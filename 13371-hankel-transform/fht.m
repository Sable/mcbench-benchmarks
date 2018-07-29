%[H,k,r,I,h]=fht(h,R;r,K;k,n;I,M,m)
%----------------------------------
%
%Quasi fast Hankel transform of order n.
%
%Input:
% h      Function h(r)
%   or
% h      Signal h(r) °
% R      Maximum radius [m]
%   or
% r      Radial positions [m] *           {default}
% K      Maximum frequency [rad/m]
%   or
% k      Spatial frequencies [rad/m] *    {default}
% n      Transform order                  {0}
%   or
% I      Integration kernel *             {default}
% M      Maximum points per cycle         {7}
% m      Minimum points per cycle         {5}
%
%Output:
% H      Spectrum H(k)
% k      Spatial frequencies [rad/m]
% r      Radial positions [m]
% I      Integration kernel
% h      Signal h(r)
%
%
% °)  Values request the presence of the kernel and samplings,
%     which can be computed with empty input.
%
% *)  The computation of the integration kernel is slow com-
%     pared to the full transform. But if the samplings and
%     the kernel are all present, they are reused as is.
%

% [1] A.E. Siegmann, Quasi fast Hankel transform,
%     Opt. Lett. 1, 13-15 (1977).
%

%     Marcel Leutenegger © June 2006
%
function [H,k,r,I,h]=fht(h,R,K,n,M,m)
if nargin < 4 | isempty(n)
   n=0;
end
N=numel(n);
if N > 1
   r=R;
   k=K;
   I=n;
else
   if ~isempty(h) & isa(h,'numeric')
      error('Need a function h(r) without kernel.');
   end
   if nargin < 5 | isempty(M)
      M=7;
   end
   if nargin < 6 | isempty(m)
      m=5;
   end
   a=K*R/2/pi;
   N=pow2(ceil(1 + log2(a*m*log(a*M))));
   a=1/a/m;
   ro=R*exp(-a*N/2);
   ko=K*exp(-a*N/2);
   I=exp(a*(0:N-1));
   k=ko*I(1:N/2);                         % samplings
   r=ro*I(1:N/2);
   I=ifft(a*ko*ro*I.*besselj(n,ko*ro*I)); % kernel
end
if isempty(h)
   H=h;
else
   if ~isa(h,'numeric')
      h=feval(h,r);
   end
   H=fft(fft(h.*r,N).*I);                 % transform
   if isreal(h)
      H=real(H);
   end
   H=2*pi*H(1:N/2)./k;
end
