function eAltitude = altitudeefficiency(h,M,throttle,assumptions)
% Change in gas turbine core thermal efficiency as function of altitude.
% 
%   relativeEfficiency = altitudeefficiency(h,M,throttle,assumptions)
% 
%   h is in meters.
% 
%   See also CALCULATEPSFC.

%% Interpolation method
%{
h0 = [0
    3474.72
    6797.04
    9083.04
    11277.6
    14630.4
    17068.8];

e0 = [0.846
    0.93
    0.978
    0.995
    1
    0.992
    0.966];

eAltitude = interp1(h0,e0,h,'linear');
%}

%% Quadratic curve fit from interpolation data
if nargin < 4
    assumptions.jnk = nan;
end
if ~isfield(assumptions,'efficiencyAtSeaLevel')
    assumptions.efficiencyAtSeaLevel = .846;
end
if ~isfield(assumptions,'hMaxEfficiency')
    assumptions.hMaxEfficiency = 11277.6; % meters (37000 ft)
end

k = (1-assumptions.efficiencyAtSeaLevel)./assumptions.hMaxEfficiency.^2;
eAltitude = 1-k.*(h-assumptions.hMaxEfficiency).^2;

end