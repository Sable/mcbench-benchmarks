function jd=doy2jd(yr,doy);
% DOY2JD  Converts year and day of year to Julian date.
% . Non-vectorized version. See also CAL2JD, GPS2JD,
%   JD2CAL, JD2DOW, JD2DOY, JD2GPS, JD2YR, YR2JD.
% Version: 24 Apr 99
% Usage:   jd=doy2jd(yr,doy)
% Input:    yr - year
%          doy - day of year
% Output:  jd  - Julian date

% Copyright (c) 2011, Michael R. Craymer
% All rights reserved.
% Email: mike@craymer.com

if nargin ~= 2
  warning('Incorrect number of arguments');
  return;
end

jd = cal2jd(yr,1,0) + doy;
