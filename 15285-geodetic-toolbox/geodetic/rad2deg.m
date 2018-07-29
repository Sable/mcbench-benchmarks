function deg=rad2deg(rad)
% RAD2DEG  Converts radians to decimal degrees. Vectorized.
% Version: 8 Mar 00
% Useage:  deg=rad2deg(rad)
% Input:   rad - vector of angles in radians
% Output:  deg - vector of angles in decimal degrees

% Copyright (c) 2011, Michael R. Craymer
% All rights reserved.
% Email: mike@craymer.com

deg=rad.*180./pi;
%ind=(deg<0);
%deg(ind)=deg(ind)+360;
