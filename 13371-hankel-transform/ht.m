%[H,I]=ht(h,r,k,I)
%-----------------
%
%Hankel transform of order 0.
%
%Input:
% h      Signal h(r)
% r      Radial positions [m]          {0:numel(h)-1}
% k      Spatial frequencies [rad/m]   {pi/numel(h)*(0:numel(h)-1)}
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
function [H,I]=ht(h,r,k,I)
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
if nargin < 4 | isempty(I)
   r=[(r(2:end) + r(1:end-1))/2 r(end)];
   I=2*pi./k(:)*r.*besselj(1,k(:)*r);
   I(k == 0,:)=pi*r.*r;
   I=I - [zeros(numel(k),1) I(:,1:end-1)];
elseif exist('w','var')
   I=I(:,w);
end
H=reshape(I*h(:),size(k));
