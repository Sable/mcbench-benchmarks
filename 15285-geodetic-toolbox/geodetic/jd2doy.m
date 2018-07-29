function [doy,yr]=jd2doy(jd);
% JD2DOY  Converts Julian date to year and day of year.
% . Non-vectorized version. See also CAL2JD, DOY2JD,
%   GPS2JD, JD2CAL, JD2DOW, JD2GPS, JD2YR, YR2JD.
% Version: 24 Apr 99
% Usage:   [doy,yr]=jd2doy(jd)
% Input:   jd  - Julian date
% Output:  doy - day of year
%          yr  - year

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

[yr,mn,dy] = jd2cal(jd);
doy = jd - cal2jd(yr,1,0);
