function jd=yr2jd(yr);
% YR2JD  Converts year and decimal of year to Julian date.
% . Non-vectorized version. See also CAL2JD, DOY2JD,
%   GPS2JD, JD2CAL, JD2DOW, JD2DOY, JD2GPS, YR2JD
% Version: 24 Apr 99
% Usage:   jd=yr2jd(yr)
% Input:   yr - year and decimal of year
% Output:  jd - Julian date

% Copyright (c) 2011, Michael R. Craymer
% All rights reserved.
% Email: mike@craymer.com

if nargin ~= 1
  warning('Incorrect number of arguments');
  return;
end

iyr = fix(yr);
jd0 = cal2jd(iyr,1,1);
days = cal2jd(iyr+1,1,1) - jd0;
doy = (yr-iyr)*days + 1;
jd = doy2jd(iyr,doy);
