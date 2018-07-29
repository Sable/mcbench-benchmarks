%[h,J]=iht(H,k,r,J)
%------------------
%
%Inverse Hankel transform of order 0.
%
%Input:
% H      Spectrum K(k)
% k      Spatial frequencies [rad/m]   {pi/numel(H)*(0:numel(H)-1)}
% r      Radial positions [m]          {0:numel(H)-1}
% J      Integration kernel °          {default}
%
%Output:
% h      Signal h(r)
% J      Integration kernel
%
%
% °)  If the integration kernel is missing, it is
%     recomputed from the Bessel functions (slow).
%

%     Marcel Leutenegger © June 2006
%
function [h,J]=iht(H,k,r,J)
if sum(size(H) > 1) > 1
   error('Spectrum must be a vector.');
end
if nargin < 2 | isempty(k)
   k=pi/numel(H)*(0:numel(H)-1).';
else
   [k,w]=sort(k(:).');
   H=H(w);
end
if nargin < 3 | isempty(r)
   r=0:numel(H)-1;
end
if nargin < 4 | isempty(J)
   k=[(k(2:end) + k(1:end-1))/2 k(end)];
   J=1/2/pi./r(:)*k.*besselj(1,r(:)*k);
   J(r == 0,:)=1/4/pi*k.*k;
   J=J - [zeros(numel(r),1) J(:,1:end-1)];
elseif exist('w','var')
   J=J(:,w);
end
h=reshape(J*H(:),size(r));
