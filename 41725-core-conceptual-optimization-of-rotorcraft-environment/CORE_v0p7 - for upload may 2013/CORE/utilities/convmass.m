function out = convmass( in, uin, uout)
%CONVMASS Convert from mass units to desired mass units.
%Allowable UI and UO strings:
% 'lbm' pounds
% 'kg' kilograms

if ~isfloat( in )
    error('Input is not floating point');
end

if nargin < 3
    uout = 'kg';
end 
    uin = lower(uin);
    uout = lower(uout);
    
%conversion to kg
if strcmp('lbm',uin)
    slope = 0.45359237; 
elseif strcmp('kg',uin)
    slope = 1;
end
    
%conversion to lbm    
if strcmp('lbm',uout)
    slope = slope/0.45359237;
elseif strcmp('kg',uout)
%     slope = slope;
else
   error('invalid output unit string')
end

out = in.*slope;