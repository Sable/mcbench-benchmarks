function [CDfuse,DLfactor] = fusepolar_arealoading(AC,tState)
% [CDfuse,DLfactor] = fusepolar_arealoading(AC,tState)
%   returns fuselage flat plate drag area and fuselage download factor as a
%   function of aircraft parameters and the current state of the aircraft.
%   See documentation for fields of tState and AC.

DLfactor = .06;

%800 psf
%4000 kg/m2
CDfuse = AC.W.AUM/4000;

end
