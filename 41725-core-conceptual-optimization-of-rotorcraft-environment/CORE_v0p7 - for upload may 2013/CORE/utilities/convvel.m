function out = convvel( in, uin, uout)
%CONVVEL Convert from velocity units to desired velocity units.
%Allowable UI and UO strings:
% 'keas' Knots equivalent airspeed
% 'm/s' metres per second
% 'kt' knots

if ~isfloat( in )
    error('Input is not floating point');
end

if nargin < 3
    uout = 'm/s';
end 
    uin = lower(uin);
    uout = lower(uout);
    
%conversion to m/s
if strcmp('kts',uin)
    slope = 0.514444444; %m/s/kts
elseif strcmp('m/s',uin)
    slope = 1;
elseif strcmp('ft/min',uin)
    slope = 5.08e-3;
else
    error('invalid input unit string')
end

%conversion from m/s
if strcmp('kts',uout)
    slope = slope/0.514444444; %keas/m/s
elseif strcmp('ft/min',uout)
    slope = slope/5.08e-3;
%else
 %  error('invalid output unit string')
end

out = in.*slope;