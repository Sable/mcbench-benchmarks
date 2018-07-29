function [PorT,etaProp,Vi,etaIdeal] = actuatordisc(task,TorP,rho,A,V,loss)
% ACTUATORDISC relates the thrust and power for an actuator disc in an
% incompressible fluid using momentum theory.
%
%   [P,etaProp,Vi,etaIdeal] = actuatordisc('computeP',T,rho,A,V,etaDisc)
%                               ====OR====
%   [T,etaProp,Vi,etaIdeal] = actuatordisc('computeT',P,rho,A,V,etaDisc)
%
%   Inputs and outputs:
%     T        - Thrust.
%     P        - Shaft power.
%     rho      - Air density.
%     A        - Disc area; can add on the order of 8% to area for nacelle.
%     V        - Speed, i.e. vehicle velocity in static fluid mass.
%     etaDisc  - Efficiency of shaft power inducing flow, Pinduced/Pshaft;
%                captures losses from swirl and viscous effects. Rough
%                values of .96 for propeller and .92 for a high bypass
%                ratio ducted fan are a reasonable starting point. Default
%                etaDisc = 1.
%     etaProp  - Efficiency of converting shaft power to thrust power.
%     Vi       - Induced flow velocity.
%     etaIdeal - Ideal efficiency. etaIdeal = V/(V+Vi).
%
%   ACTUATORDISC does no unit conversion, so units must be consistent and
%   use the pure form, i.e. power in ft-lbf/s instead of horsepower.
%   ACTUATORDISC accepts DimensionedVariable arguments, the use of which
%   will ensure unit consistency.
%
%   See also DEMOENGINEDECK, CALCULATEPSFC,
%       UNITS - http://www.mathworks.com/matlabcentral/fileexchange/38977.
%
%   [P,etaProp,Vi,etaIdeal] = actuatordisc('computeP',T,rho,A,V,etaDisc)
%   [T,etaProp,Vi,etaIdeal] = actuatordisc('computeT',P,rho,A,V,etaDisc)

%   Copyright 2013 Sky Sartorius
%   Author contact: mathworks.com/matlabcentral/fileexchange/authors/101715

if nargin < 6
    loss = 1;
end
if nargin < 5 || isempty(V)
    V = 0; % Static thrust case (zero taken care of later)
end

switch upper(task(1:8))
    case 'COMPUTEP'
        T = TorP; % Net thrust produced; thrust required
        
        Vi = Vinduced(T,rho,A,V);
        Pinduced = T.*(V+Vi); % Induced power
        
        Pshaft = Pinduced./loss;
        PorT = Pshaft;
        
    case 'COMPUTET'
        Pshaft = TorP; % Shaft power as input
        Pinduced = Pshaft.*loss;
        
        T = actuatordiscthrust(Pinduced,rho,A,V);
        % ACTUATORDISCTHRUST provides an exact closed-form solution to
        % actuator disc momentum theory that allows solving for thrust for
        % a given induced power without iteration. Solution is undefined
        % for P = 0 (ans: T = 0), but P = eps works.
        % Syntax: T = ACTUATORDISCTHRUST(P,rho,A,V)
        
        PorT = T;
        
        Vi = Vinduced(T,rho,A,V);
end

etaIdeal = V./(V+Vi);
etaProp = T.*V./Pshaft;
end

function Vi = Vinduced(T,rho,A,V)
ViStatic = sqrt(T./(2*rho.*A));
Vi = -V/2+ViStatic.*sqrt((V./(2*ViStatic)).^2+1);
end

% Revision history
%{
2013-03-18 added handling of V = 0 input
2013-04-07 help formatting
2013-07-03
    derived a more succinct and robust (e.g. now defined for V,rho,A=0)
    closed-form solution for actuatordiscthrust and moved it from the
    subfunction into a p file so I can share it.
%}
