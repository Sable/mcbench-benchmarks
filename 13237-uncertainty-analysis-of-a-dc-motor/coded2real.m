function x = coded2real(z,bounds)
%CODED2REAL Converts coded variables into real values.
% CODED2REAL converts the coded values in Z to real values defined by
% BOUNDS.  Columns of Z are different factors (variables/observations).
% Rows of BOUNDS are the defining limits in order of increasing value.
%
% Example:
%   A Design of Experiment - Cooling Fan Factors (3):
%   Distance from radiator:  1 to 1.5 inches
%   Pitch angle:             15 to 35 degrees
%   Blade tip clearance:     1 to 2 inches
%
%   z = bbdesign(3) % Box-Behnken Response Surface Design with 3 factors
%   bounds = [1 1.5;    % min and max values for each factor (Distance)
%             15 35;    % Pitch Angle
%               1 2];   % Tip Clearance
%   x = coded2real(z,bounds)    % Real values from the coded values

for i = 1:size(z,2)
    zmax = max(z(:,i));
    zmin = min(z(:,i));
    x(:,i) = interp1([zmin zmax],bounds(i,:),z(:,i));
end