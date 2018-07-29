% script to test MATLAB's gradient routine
%
% Written by:    Lt Col Robert A. Canfield
%                Air Force Institute of Technology
%                AFIT/ENY
%                2950 P Street, Bldg. 640
%                WPAFB, OH  45433-7765
%                Robert.Canfield@afit.af.mil
%
% Created:       10/19/00
% Last modified: 10/23/00
%
% Note:     MATLAB's gradient function is incorrect for un-evenly spaced coordinates.
%           The central_diff function uses the correct formula.
%           Tested under MATLAB versions 5.2 and 5.3.1.
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

% Demsontration that MATLAB's gradient function is inaccurate
% for unevenly spaced coordinate data, using the sin function.
x  = 1:pi/20:pi;
yp = gradient( sin(x), x );
grad_error = [max(yp-cos(x)); min(yp-cos(x)); mean(abs(yp-cos(x)))];
disp('For MATLAB gradient function used on sin(x) ...')
disp(['Maximum error with even spacing =  ',num2str(max(yp-cos(x)))])
disp(['Minimum error with even spacing = ', num2str(min(yp-cos(x)))])
disp(['Mean absolute error with even spacing = ',num2str(mean(abs(yp-cos(x))))])
disp(' ')
% Add increment to every other base point
i = 2:2:length(x);
x(i) = x(i) + pi/40;
yp = gradient( sin(x), x );
grad_error(:,2) = [max(yp-cos(x)); min(yp-cos(x)); mean(abs(yp-cos(x)))];
disp(['Maximum error with un-even spacing =  ',num2str(max(yp-cos(x)))])
disp(['Minimum error with un-even spacing = ', num2str(min(yp-cos(x)))])
disp(['Mean absolute error with un-even spacing = ',num2str(mean(abs(yp-cos(x))))])
disp(' ')
disp('Ratio of un-even to even spacing error for max, min, mean abs')
disp(grad_error(:,2)./grad_error(:,1))
disp(' ')
disp(' ')


% Repeat for new central_diff function.
x  = 1:pi/20:pi;
yp = central_diff( sin(x), x );
grad_error = [max(yp-cos(x)); min(yp-cos(x)); mean(abs(yp-cos(x)))];
disp('For central_diff ...')
disp(['Maximum error with even spacing =  ',num2str(max(yp-cos(x)))])
disp(['Minimum error with even spacing = ', num2str(min(yp-cos(x)))])
disp(['Mean absolute error with even spacing = ',num2str(mean(abs(yp-cos(x))))])
disp(' ')
% Add increment to every other base point
x(i) = x(i) + pi/40;
yp = central_diff( sin(x), x );
grad_error(:,2) = [max(yp-cos(x)); min(yp-cos(x)); mean(abs(yp-cos(x)))];
disp(['Maximum error with un-even spacing =  ',num2str(max(yp-cos(x)))])
disp(['Minimum error with un-even spacing = ', num2str(min(yp-cos(x)))])
disp(['Mean absolute error with un-even spacing = ',num2str(mean(abs(yp-cos(x))))])
disp(' ')
disp('Ratio of un-even to even spacing error for max, min, mean abs')
disp(grad_error(:,2)./grad_error(:,1))
