function mjd=jd2mjd(jd)
% JD2MJD  Converts Julian Date to Modified Julian Date.
%   Non-vectorized version. See also CAL2JD, DOY2JD, GPS2JD,
%   JD2CAL, JD2DOW, JD2DOY, JD2GPS, JD2YR, MJD2JD, YR2JD.
% Version: 2010-03-25
% Usage:   mjd=jd2mjd(jd)
% Input:   jd  - Julian date
% Output:  mjd - Modified Julian date

% Copyright (c) 2011, Michael R. Craymer
% All rights reserved.
% Email: mike@craymer.com

if nargin ~= 1
  warning('Incorrect number of arguments');
  return;
end

mjd=jd-2400000.5;
