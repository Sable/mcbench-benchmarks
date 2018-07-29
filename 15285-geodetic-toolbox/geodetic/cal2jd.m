function jd=cal2jd(yr,mn,dy)
% CAL2JD  Converts calendar date to Julian date using algorithm
%   from "Practical Ephemeris Calculations" by Oliver Montenbruck
%   (Springer-Verlag, 1989). Uses astronomical year for B.C. dates
%   (2 BC = -1 yr). Non-vectorized version. See also DOY2JD, GPS2JD,
%   JD2CAL, JD2DOW, JD2DOY, JD2GPS, JD2YR, YR2JD.
% Version: 2011-11-13
% Usage:   jd=cal2jd(yr,mn,dy)
% Input:   yr - calendar year (4-digit including century)
%          mn - calendar month
%          dy - calendar day (including factional day)
% Output:  jd - jJulian date

% Copyright (c) 2011, Michael R. Craymer
% All rights reserved.
% Email: mike@craymer.com

if nargin ~= 3
  warning('Incorrect number of input arguments');
  return;
end
if mn < 1 | mn > 12
  warning('Invalid input month');
  return
end
if dy < 1
  if (mn == 2 & dy > 29) | (any(mn == [3 5 9 11]) & dy > 30) | (dy > 31)
    warning('Invalid input day');
    return
  end
end

if mn > 2
  y = yr;
  m = mn;
else
  y = yr - 1;
  m = mn + 12;
end
date1=4.5+31*(10+12*1582);   % Last day of Julian calendar (1582.10.04 Noon)
date2=15.5+31*(10+12*1582);  % First day of Gregorian calendar (1582.10.15 Noon)
date=dy+31*(mn+12*yr);
if date <= date1
  b = -2;
elseif date >= date2
  b = fix(y/400) - fix(y/100);
else
  warning('Dates between October 5 & 15, 1582 do not exist');
  return;
end
if y > 0
  jd = fix(365.25*y) + fix(30.6001*(m+1)) + b + 1720996.5 + dy;
else
  jd = fix(365.25*y-0.75) + fix(30.6001*(m+1)) + b + 1720996.5 + dy;
end
