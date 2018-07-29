function out = convpower( in, uin, uout )
%  CONVPOWER Convert from power units to desired power units.
%   OUT = CONVPOWER( IN, UI, UO ) converts the input power IN (floating
%   point array) from unit specified in UI (string) to unit specified in UO
%   (string). If UO is not specified, IN is converted to the SI unit, which
%   is Watts.
%
%   Allowable input/output strings (not case sensitive):
%      'hp'          :horsepower     
%      'W'           :watt
%      'kW'          :kilowatt
%      'lbf-ft/s'    :pound-feet/second (also 'lb-ft/s' or 'ft-lb/s')
%
%   Example:
%
%   Convert a matrix of power values from lbf-ft/s to hp:
%       hp = convpower([2 3; 4 5], 'lbf-ft/s', 'hp')
%
%   See also in aerospace toolbox CONVACC, CONVANG, CONVANGACC, CONVANGVEL,
%   CONVDENSITY, CONVFORCE, CONVLENGTH, CONVMASS, CONVPRES, CONVTEMP,
%   CONVVEL.

%   Author: Sky Sartorius
%   http://www.mathworks.com/matlabcentral/fileexchange/authors/101715

if ~isfloat( in )
    error('Input is not floating point');
end
if nargin < 3
    uout = 'w';
end
uin = lower(uin);
uout = lower(uout);
%conversion to watts
if strcmp('hp',uin)
    slope = 745.6998716; %W/hp
elseif strcmp('kw',uin)
    slope = 1000; %W/kW
elseif strcmp('lbf-ft/s',uin) || strcmp('lb-ft/s',uin) || strcmp('ft-lb/s',uout)
    slope = 1.355817948363637; %lb-ft/s/W
elseif strcmp('w',uin)
    slope = 1;
else
    error('invalid input unit string')
end

%conversion from watts
if strcmp('hp',uout)
    slope = slope/745.6998716; %W/hp
elseif strcmp('kw',uout)
    slope = slope/1000; %W/kW
elseif strcmp('lbf-ft/s',uout) || strcmp('lb-ft/s',uout) || strcmp('ft-lb/s',uout)
    slope = slope/1.355817948363637; %lb-ft/s/W
elseif strcmp('w',uout)
%     slope = slope/1;
else
    error('invalid output unit string')
end

out = in.*slope;