%[h,I]=ihat(H,k,r,n;I)
%---------------------
%
%Inverse Hankel transform of order n.
%
%Input:
% H      Spectrum K(k)
% k      Spatial frequencies [rad/m]   {pi/numel(H)*(0:numel(H)-1)}
% r      Radial positions [m]          {0:numel(H)-1}
% n      Transform order               {0}
%   or
% I      Integration kernel °          {default}
%
%Output:
% h      Signal h(r)
% I      Integration kernel
%
%
% °)  If the integration kernel is missing, it is
%     recomputed from the Bessel functions (slow).
%

%     Marcel Leutenegger © June 2006
%
function [h,I]=ihat(H,k,r,n)
if sum(size(H) > 1) > 1
   error('Spectrum must be a vector.');
end
if nargin < 2 | isempty(k)
   k=pi/numel(H)*(0:numel(H)-1).';
else
   [k,w]=sort(k(:));
   H=H(w);
end
if nargin < 3 | isempty(r)
   r=0:numel(H)-1;
end
if nargin < 4 | isempty(n)
   n=0;
end
if numel(n) > 1
   if exist('w','var')
      I=n(w,:);
   else
      I=n;
   end
else
   I=besselj(n,k*r(:).');
end
h=reshape(frdr(H,k).'*I/(2*pi)^2,size(r));
