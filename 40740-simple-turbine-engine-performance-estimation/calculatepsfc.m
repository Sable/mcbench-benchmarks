function [PSFC,eProd,e] = calculatepsfc(h,M,throttle,assumptions)
% CALCULATEPSFC calculates gas turbine power specific fuel consumption as a
% function of altitude, Mach number, and throttle setting.
%
%   [PSFC,eProd,e] = CALCULATEPSFC(h,M,throttle,assumptions)
%
%   Inputs and outputs:
%   PSFC        - Power specific fuel consumption.
%   eProd       - Core thermal efficiency at operating point.
%   e           - Cell vector with breakdown of eProd; eProd = prod(e).
%   h           - Altitude in meters.
%   M           - Mach number.
%   throttle    - Throttle setting (range 0 to 1). Default is 1.
%   assumptions - Struct with fields:
%     Q            - Fuel heating value. Default is 43e6 J/kg (Jet A fuel).
%                    Units of Q determine the units of PSFC, for example,
%                    PSFC is in (kg/s)/(J/s) for Q in J/kg.
%     efficiencies - Cell vector defining constants and functions that
%                    together determine the total core thermal efficiency.
%                    Elements may be numeric or function handles of the
%                    form relativeEfficiency = f(h,M,throttle,assumptions).
%                    Default is {maxEfficiency,@throttleefficiency,...
%                    @altitudeefficiency}, where maxEfficiency is 0.4.
%
%   CALCULATEPSFC accepts arguments of the DimensionedVariable class, the
%   use of which will ensure unit consistency.
%
%   See also DEMOENGINEDECK, ACTUATORDISC, POWERLAPSE,
%       THROTTLEEFFICIENCY, ALTITUDEEFFICIENCY,
%       UNITS - http://www.mathworks.com/matlabcentral/fileexchange/38977.
%
%   [PSFC,eProd,e] = CALCULATEPSFC(h,M,throttle,assumptions)

%   Copyright 2013 Sky Sartorius
%   Author contact: mathworks.com/matlabcentral/fileexchange/authors/101715

if nargin < 4 || isempty(assumptions)
    assumptions.jnk = nan;
    disp('Default assumptions and efficiency models in use.')
end
if ~isfield(assumptions,'Q')
    assumptions.Q = 43e6; %J/kg Jet A fuel
    % assumptions.Q = 120e6; %MJ/kg liquid hydrogen
end
if ~isfield(assumptions,'efficiencies')
    eMax = 0.4;
    assumptions.efficiencies = ...
        {eMax,@altitudeefficiency,@throttleefficiency};
end

if nargin < 3
    throttle = 1;
end

e = cell(size(assumptions.efficiencies));
eProd = 1;
for ii = 1:length(assumptions.efficiencies)
    if iscell(assumptions.efficiencies)
        jnk = assumptions.efficiencies{ii};
    else
        jnk = assumptions.efficiencies(ii);
    end
    
    if isnumeric(jnk) % constant efficiency multiplier
        e{ii} = jnk;
    else
        e{ii} = jnk(h,M,throttle,assumptions);
    end
    eProd = eProd.*e{ii};
end

massPerUnitEnergy = 1/assumptions.Q;
PSFC = massPerUnitEnergy./eProd;

end

% Revision history
%{
2013-04-07 help formatting
%}