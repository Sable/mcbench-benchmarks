function dow=jd2dow(jd);
% JD2DOW  Converts Julian date to day of week (Sun=1,...,Sat=7)
%   Adapted from the algorithm from "Practical Astronomy with
%   Your Calculator" (Third Edition) by Peter Duffett-Smith,
%   Cambridge Univeristy Press, 1988. Non-vectorized version.
%   See also CAL2JD, DOY2JD, GPS2JD, JD2CAL, JD2DOY, JD2GPS,
%   JD2YR, YR2JD.
% Version: 24 Apr 99
% Usage:   dow=jd2dow(jd)
% Input:   jd  - Julian date
% Output:  dow - day of week (1=Sun,...,7=Sat)

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

dow = floor(rem(jd+1.5,7))+1;
