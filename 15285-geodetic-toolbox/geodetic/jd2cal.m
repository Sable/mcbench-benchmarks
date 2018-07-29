function [yr,mn,dy]=jd2cal(jd)
% JD2CAL  Converts Julian date to calendar date using algorithm
%   from "Practical Ephemeris Calculations" by Oliver Montenbruck
%   (Springer-Verlag, 1989). Must use astronomical year for B.C.
%   dates (2 BC = -1 yr). Non-vectorized version. See also CAL2JD,
%   DOY2JD, GPS2JD, JD2DOW, JD2DOY, JD2GPS, JD2YR, YR2JD.
% Version: 24 Apr 99
% Usage:   [yr, mn, dy]=jd2cal(jd)
% Input:   jd - Julian date
% Output:  yr - year of calendar date
%          mn - month of calendar date
%          dy - day of calendar date (including decimal)

% Copyright (c) 2011, Michael R. Craymer
% All rights reserved.
% Email: mike@craymer.com

if nargin ~= 1
  warning('Incorrect number of arguments');
  return;
end
if jd < 0
  warning('Julian date must be greater than or equal to zero');
  return;
end

a = fix(jd+0.5);
if a < 2299161
  c = a + 1524;
else
  b = fix( (a-1867216.25) / 36524.25 );
  c = a + b - fix(b/4) + 1525;
end
d = fix( (c-122.1)/365.25 );
e = fix(365.25*d);
f = fix( (c-e) / 30.6001 );
dy = c - e - fix(30.6001*f) + rem((jd+0.5),a);
mn = f - 1 - 12*fix(f/14);
yr = d - 4715 - fix( (7+mn)/10 );
