function yr=jd2yr2(jd);
% JD2YR2  Converts Julian date to year and decimal of year
%   using the following conversion from MJD:
%       yr = 1970 + (mjd - 40587 + 0.5) / 365.25
%   Non-vectorized version. See also CAL2JD, DOY2JD, GPS2JD,
%   JD2CAL, JD2DOW, JD2DOY, JD2GPS, JD2MJD, JD2YR, MJD2JD.
% Version: 2010-03-25
% Usage:   yr=jd2yr2(jd)
% Input:   jd - Julian date
% Output:  yr - year and decimal of year

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

mjd=jd2mjd(jd);
yr = 1970+(mjd-40587+0.5)/365.25;
