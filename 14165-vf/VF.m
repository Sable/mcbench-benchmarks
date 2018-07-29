function [fi,ps] = VF(r,T,p)
% VF Conversion of relative humidity to volume fraction of water vapor
%
% This program transfers relative humidity, absolute temperature and 
% atmospheric pressure to volume fraction of water vapor and saturation
% vapour pressure using Goff-Gratch equation over plane surfaces of pure
% ice. Relation is based on integration of Clausius-Clapeyron equation and
% on experimental data. Stated range of equation validity is -100 to 0 °C.
%
% [fi,ps] = VF(r,T,p)
%
% Inputs:
%   r is the relative humidity (%). r may be a vector or a scalar
%     variable in the interval [0,100].
%
%   T means the absolute temperature (degrees K). T must have 
%     the same number of elements as r. A warning is generated
%     if any elements fall outside the range [173,273].
%
%   p is the atmospheric pressure (kPa). p must have the same number
%     of elements as r. All elements must be non-negative.
%
% Results:
%   fi is the volume fraction of water vapor (%).
%
%   ps is the saturation vapour pressure (kPa).
%
% Example: At an rh of 35 %, Temp = 265 °K, atmospheric pressure = 98.9 kPa
%  [fi,ps] = VF(0.35,265,98.9)
%
%   fi =
%       0.00108
%
%   ps =
%       0.305
% 
% For citation ensue following format: Malec L. (2007). VF: Conversion
% of relative humidity to volume fraction. A MATLAB file. [WWW document].
% URL http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?
% objectId=14165
%
% List R. J.: Smithsonian Meteorological Tables. Smithsonian Institution,
% Washington 1984.
%
% Copyright. February 26, 2007.


if any(r(:)<0) || any(r(:)>100)
  error 'Relative humidity(r) must be percent'
end
if any(T(:)<=0)
  error 'Temperature(T) must be positive (°K)'
elseif any(T(:)<173) || any(T(:)>273)
  warning 'Temperature(T) fell outside the working range of this relation'
end
if any(p(:)<0)
  error 'Pressure(p) must be positive (kPa)'
end

a1 = -9.09718;
a2 = -3.56654;
a3 = 0.876793;

% Induction of ice point and saturation vapour pressure.
To = 273.16;
eo = 6.1071;

% Saturation vapour pressure and water fraction computation.
ps = 10.^(a1 * (To ./ T - 1) + a2 * log10(To ./ T) + a3 * (1 - T / To) ...
    + log10(eo));
ps = ps / 10;
fi = r .* ps ./ p;

