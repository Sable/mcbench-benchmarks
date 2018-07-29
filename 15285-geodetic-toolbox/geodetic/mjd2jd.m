function jd=mjd2jd(mjd)
% MJD2JD  Converts Modified Julian Date to Julian Date.
%   Non-vectorized version. See also CAL2JD, DOY2JD, GPS2JD,
%   JD2CAL, JD2DOW, JD2DOY, JD2GPS, JD2MJD, JD2YR, YR2JD.
% Version: 2010-03-25
% Usage:   jd=mjd2jd(mjd)
% Input:   mjd - Modified Julian date
% Output:  jd  - Julian date

% Copyright (c) 2011, Michael R. Craymer
% All rights reserved.
% Email: mike@craymer.com

if nargin ~= 1
  warning('Incorrect number of arguments');
  return;
end

jd=mjd+2400000.5;
