function Fx = central_diff( F, x )
% central_diff   Central Difference Gradient
%
% usage:    gradient = central_diff( F, x )
%
% inputs:   F - Values of a scalar function evaluated at x 
%               to be differentiated with respect to x
%           x - vector of monotonically increasing coordinates where F is evaluated,
%               or a scalar for evenly spaced coordinates
%
% output:  gradient - numerically evaluated gradient by:
%                     forward difference at the left end;
%                     backward difference at the right end;
%                     central difference in the interior
%
% Written by:    Lt Col Robert A. Canfield
%                Air Force Institute of Technology
%                AFIT/ENY
%                2950 P Street, Bldg. 640
%                WPAFB, OH  45433-7765
%                Robert.Canfield@afit.af.mil
%
% Created:       10/19/00
% Last modified: 10/01/01
%
% Note:     MATLAB's gradient function is not second-order accurate
%           for un-evenly spaced coordinates.
%           This central_diff function uses the correct central difference 
%           formula (for interior points) that is second-order accurate 
%           for both evenly and un-evenly spaced coordinates.
%           Tested under MATLAB versions 5.2, 5.3.1, and 6.0.
%
% Alternatively, you may patch MATLAB's gradient function by 
% replacing the lines...
%   % Take centered differences on interior points
%   if n > 2
%      h = h(3:n) - h(1:n-2);
%      g(2:n-1,:) = (f(3:n,:)-f(1:n-2,:))./h(:,ones(p,1));
%   end
%
% with...
%   % Take centered differences on interior points
%   if n > 2
%      if all(abs(diff(h,2)) < eps) % only use for uniform h (RAC)
%         h = h(3:n) - h(1:n-2);
%         g(2:n-1,:) = (f(3:n,:)-f(1:n-2,:))./h(:,ones(p,1));
%      else   % new formula for un-evenly spaced coordinates (RAC)
%         h = diff(h); h_i=h(1:end-1,ones(p,1)); h_ip1=h(2:end,ones(p,1));
%         g(2:n-1,:) =  (-(h_ip1./h_i).*f(1:n-2,:) + ...
%                         (h_i./h_ip1).*f(3:n,:)   )./ (h_i + h_ip1) + ...
%                         ( 1./h_i - 1./h_ip1 ).*f(2:n-1,:);
%      end
%   end


% Ensure compatible vectors and x monotonically increasing or decreasing
if nargin<2
	m = 1;
   h = 1;
   x = 1;
else
	m = length(x);
end
Tflag = 0;
if ndims(F)==2 & size(F,1)==1    % Treat row vector as a column vector
   F = F.';
   Tflag = 1;
end;

[n,p] = size(F);
if m==0
   error('x cannot be null')
elseif m~=1 & m~=n
	error('First dimension of F and x must be the same.')
elseif m>1 & ~( all(diff(x)>0) | all(diff(x)<0) )
	error('Vector x must be monotonically increasing or decreasing.')
elseif n<=1
   Fx = F / x;
   return
end

Fx = zeros(size(F));
x  = x(:);

% Forward difference at left end
if m==1
	h = x;
else
	h = x(2) - x(1); 
end
Fx(1,:) = ( F(2,:) - F(1,:) ) / h;

% Backward difference at right end
if m>1, h = x(m) - x(m-1); end
Fx(n,:) = ( F(n,:) - F(n-1,:) ) / h;

% Central Difference in interior
if n > 3
	if m==1 | all(diff(x)==h) % Evenly spaced formula used in MATLAB's gradient routine
		Fx(2:n-1) = ( F(3:n,:) - F(1:n-2,:) ) / (2*h);
   else
		h = diff(x); h_i=h(1:m-2,ones(p,1)); h_ip1=h(2:m-1,ones(p,1));
		Fx(2:n-1,:) =  (-(h_ip1./h_i).*F(1:n-2,:) + ...
		                 (h_i./h_ip1).*F(3:n,:)   )./ (h_i + h_ip1) + ...
		        ( 1./h_i - 1./h_ip1 ).*F(2:n-1,:);
	end
end
if Tflag, Fx=Fx.'; end