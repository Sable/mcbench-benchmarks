function [Pavail, Tavail, Tfuelburn, Pfuelburn, totalfuelburn] = ...
    plapse_simple(AC, tState, Treq, Preq)
% Inputs:
%   AC: see documentation
%   tState: see documentation
%   Treq: thrust required (N)
%   Preq: power required (W) including tail rotor, main rotor, and
%   accessories
%
% Outputs:
%   Pavail: power available (W)
%   Tavail: thrust available (N)
%   Tfuelburn: fuel burn from forward propulsion
%   Pfuelburn: fuel burn from power production
%   totalfuelburn: the sum of Tfuelburn and Pfuelburn

%number of power-producing engines
nP = 2;
% nP = round(AC.Vars.nPowerEngines);

% OEI
% OEI = tState.OEI;
OEI = 0;

% engine condition
% switch tState.EngCond
%     case 0 %continuous power
%         Pfactor = .85;
%         Tfactor = .9;
%     case 1 %takeoff/30min power
%         Pfactor = 1;
%         Tfactor = 1;
%     case 2 %OEI/emergency
%         Tfactor = 1;
%         Pfactor = 1.1;
% end
Pfactor = 1;
Tfactor = 1;

if nargin <4; Preq = NaN;end
if nargin <3; Treq = NaN;end


PSFC0 = .4; %lb/hp-h UNISTALLED! PSFC
PSFC0 = 0.000608277388*PSFC0; %kg/W-h

TSFC0 = .5; %lb/lbf-h UNISTALLED! TSFC
TSFC0 = TSFC0*0.102; %kg/N-h

[Plossfactor, Tlossfactor] = installation_and_losses(AC);

PSFC = PSFC0/Plossfactor; %installed PSFC
TSFC = TSFC0/Tlossfactor; %installed PSFC

sigma = tState.rho/1.225;
aratio = tState.a/340.2940;

Pinstalled = AC.Power.P*Plossfactor; %installed power for rotors and accessories

Pavail = (Pinstalled .* sigma).*((nP - OEI)./nP);
c = Preq/Pavail;
Pavail = Pavail*Pfactor;

if Preq > 0
    %temperature correction
    PSFC = PSFC*aratio;
    %throttle setting correction;
    PSFC = PSFC*(.1./c+.24./c.^.8+.66.*c.^.8);
    
    Pfuelburn = PSFC * Preq; %kg/hr
else
    Pfuelburn = 0;
end

if AC.Power.T
    Tinstalled = AC.Power.T*Tlossfactor;
    Tavail = Tinstalled .* sigma;
    cthrust = Treq/Tavail;
    Tavail = Tavail*Tfactor;
    if Treq > 0
        %temperature correction
        TSFC = TSFC*aratio;
        %throttle setting correction;
        TSFC = TSFC*.1./cthrust+.24./cthrust.^.8+.66.*cthrust.^.8+.1*(tState.V/tState.a).*(1./cthrust-cthrust);
        Tfuelburn = TSFC * Treq; %kg/hr
    else
        Tfuelburn = 0;
    end
else
    Tavail = 1e-15;
    Tfuelburn = 0;
end

totalfuelburn = Tfuelburn + Pfuelburn; %kg/h

Pfuelburn = Pfuelburn/3600; %kg/s
Tfuelburn = Tfuelburn/3600; %kg/s
totalfuelburn = totalfuelburn/3600; %kg/s
end

function [Plossfactor, Tlossfactor] = installation_and_losses(AC)

Pavail = AC.Power.P;

% engine installation and transmission losses
% % inlet duct friction
Pavail = Pavail*(1-.01);
% inlet particle separator
Pavail = Pavail*(1-0);
% exhause back pressure due to friction
Pavail = Pavail*(1-.01);
% IR suppressor
Pavail = Pavail*(1-0);
% Inlet temp rise due to reingestion
Pavail = Pavail*(1-.005);
% compressor bleed
Pavail = Pavail*(1-.03);
% gearbox loss
Pavail = Pavail*(1-.04);

Plossfactor = Pavail./AC.Power.P;


Tavail = AC.Power.T;
% installation loss
Tavail = Tavail*(1-.1);
% engine mounted accessories
Tavail = Tavail*(1-.02);

Tlossfactor = Tavail./AC.Power.T;
end