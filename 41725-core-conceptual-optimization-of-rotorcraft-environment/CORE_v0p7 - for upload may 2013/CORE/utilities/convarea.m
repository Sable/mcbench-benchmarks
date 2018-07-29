function out = convarea( in, uin, uout )
%  CONVAREA Convert from area units to desired area units.
%   OUT = CONVAREA( IN, UI, UO ) converts the input area IN
%   (floating point array) from unit specified in UI (string) to unit
%   specified in UO (string). 
% 
%   Allowable UI and UO strings (not case sensitive):
%      'ft2','sqft'         :square feet
%      'm2','sqm'           :square meters
%      'km2','sqkm'         :square kilometers
%      'in2','sqin'         :square inches
%      'mi2','sqmi'         :square miles  
%      'naut mi2',          :square nautical miles
%
%   If UO is not specified, IN is converted from UI to the SI unit, square
%   meters.
%
%   See also CONVACC, CONVANG, CONVANGACC, CONVANGVEL, CONVDENSITY,
%   CONVFORCE, CONVLENGTH, CONVMASS, CONVPRES, CONVTEMP, CONVVEL.
%
%   Author: Sky Sartorius
%   http://www.mathworks.com/matlabcentral/fileexchange/authors/101715

% Revision history:
%       V1.0    16 July 2010

if ~isfloat( in )
    error('Input is not a floating point number');
end

if nargin < 3
    uout = 'm2';
end

%convert to ft2
if strcmpi('m2',uin)
    slope=10.7639;
elseif strcmpi('ft2',uin)
    slope = 1;
end

if strcmpi('m2',uout)
    slope = 1/10.7639;
%else
 % error('invalid output unit string')
end

%slope = (unitconversion('length conversion',uin,uout,0))^2;

out = in.*slope;

