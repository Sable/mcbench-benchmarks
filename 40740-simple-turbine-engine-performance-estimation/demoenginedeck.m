function [Tavail,TSFC,fuelFlow,etaProp,eCoreTotal,eCore] = ...
    demoenginedeck(Pshaftsls,fanArea,h,M,Treq,assumptions)
%   Example engine deck function as a demonstration of simple propulsion
%   modeling tools.
% 
%   [Tavail,TSFC,fuelFlow,etaProp,eCoreTotal,eCore] = ...
%                    DEMOENGINEDECK(Pshaftsls,fanArea,h,M,Treq,assumptions)
% 
%   Note: PslsShaft can be estimated from Tsls:
%    PslsShaft = actuatordisc('computeP',Tsls,rho0,fanArea,eps,etaDiscStat)
%    where rho0 is sea level density, 1.225 kg/m^3
% 
%   Example:
%       Psls = 37e6; A = 7.5;
%       myDeck = @(h,M,Treq) demoenginedeck(Psls,A,h,M,Treq,[]);
% 
%       M = .4:.05:.9; h = 0:250:15000; % meters
%       [h,M] = meshgrid(h,M);
% 
%       [Tavail,~,~,etaProp] = myDeck(h,M,[]);
%       [~,TSFC] = myDeck(h,M,Tavail);
% 
%       Tref = Tavail/actuatordisc('computeT',Psls,1.225,A,eps,.92);
%       TSFCh = 35304*TSFC;
% 
%       [~,H] = contourf(M,h,TSFCh,200);
%       set(H,'LineStyle','none'); colorbar;
%       xlabel('M'); ylabel('Altitude (m)')
%       title('Contours of TSFC (lb_m/hr/lb_f)')
% 
%       figure; [~,H] = contourf(M,h,Tref,200);
%       set(H,'LineStyle','none'); colorbar;
%       xlabel('M'); ylabel('Altitude (m)');
%       title('Contours of T_{available}/T_{s.l. static}');
% 
%   See also ACTUATORDISC, CALCULATEPSFC,
%     POWERLAPSE, THROTTLEEFFICIENCY, ALTITUDEEFFICIENCY, 
%     STDATMO - http://www.mathworks.com/matlabcentral/fileexchange/28135.

%   Copyright 2013 Sky Sartorius
%   Author contact: mathworks.com/matlabcentral/fileexchange/authors/101715

% Default assumptions 
if nargin < 5 || isempty(assumptions)
    assumptions.etaDisc                 = .92;
    assumptions.Q                       = 43e6; %J/kg Jet A fuel
    % assumptions.Q                       = 120e6; %MJ/kg liquid hydrogen
    assumptions.efficiencyAtSeaLevel    = .846;
    assumptions.hMaxEfficiency          = 11277.6; % meters (37000 ft)
    assumptions.efficiencies            = ...
        {.4,@throttleefficiency,@altitudeefficiency};
    assumptions.powerlapse              = @powerlapse;
end

% Flight conditions
[rho,a] = atmos(h);
V = M.*a;

% Step 1: Find available thrust
if isnumeric(assumptions.powerlapse)
    lapse = assumptions.powerlapse;
else
    lapse = assumptions.powerlapse(h,M,assumptions);
end
PshaftAvail = lapse.*Pshaftsls;
[Tavail,etaProp] = ...
    actuatordisc('computeT',PshaftAvail,rho,fanArea,V,assumptions.etaDisc);

% Step 2: Find fuel consumption
if nargin<4 || isempty(Treq)
    [TSFC,fuelFlow,eCoreTotal,eCore] = deal([]);
    return
end

PshaftReq =actuatordisc('computeP',Treq,rho,fanArea,V,assumptions.etaDisc);

throttle = PshaftReq./PshaftAvail;

[PSFC,eCoreTotal,eCore] = calculatepsfc(h,M,throttle,assumptions);

fuelFlow = PshaftReq.*PSFC;

TSFC = fuelFlow./Treq;

end

function [rho,a] = atmos(h)
if exist('stdatmo','file') >= 2
    [rho,a] = stdatmo(h);
elseif exist('atmosisa','file') >= 2
    [T,~,~,rho] = atmosisa(h);
    a = sqrt(1.4*287.05287*T);
else
    link = 'http://www.mathworks.com/matlabcentral/fileexchange/28135';
    a='Standard atmosphere model on MATLAB path required';
    b=['<a href="' link '">STDATMO on file exchange</a>'];
    c=['<a href="' link '?download=true">STDATMO direct download</a>'];
    error('%s.\n%s\n%s',a,b,c)
end
end

% Revision History
%{
2013-03-11 uploaded to file exchange along with associated functions
2013-05-07 help block updates
2013-05-07 uploaded to FEX
%}