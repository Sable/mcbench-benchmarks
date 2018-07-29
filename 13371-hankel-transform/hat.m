%[H,I]=hat(h,r,k,n;I)
%--------------------
%
%Hankel transform of order n.
%
%Input:
% h      Signal h(r)
% r      Radial positions [m]          {0:numel(h)-1}
% k      Spatial frequencies [rad/m]   {pi/numel(h)*(0:numel(h)-1)}
% n      Transform order               {0}
%   or
% I      Integration kernel °          {default}
%
%Output:
% H      Spectrum H(k)
% I      Integration kernel
%
%
% °)  If the integration kernel is missing, it is
%     recomputed from the Bessel functions (slow).
%

%     Marcel Leutenegger © June 2006
%
function [H,I]=hat(h,r,k,n)
if sum(size(h) > 1) > 1
   error('Signal must be a vector.');
end
if nargin < 2 | isempty(r)
   r=0:numel(h)-1;
else
   [r,w]=sort(r(:).');
   h=h(w);
end
if nargin < 3 | isempty(k)
   k=pi/numel(h)*(0:numel(h)-1);
end
if nargin < 4 | isempty(n)
   n=0;
end
if numel(n) > 1
   if exist('w','var')
      I=n(:,w);
   else
      I=n;
   end
else
   I=besselj(n,k(:)*r);
end
H=reshape(I*frdr(h,r),size(k));
