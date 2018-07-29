function rad=sec2rad(sec)
% SEC2RAD  Converts seconds of arc to radians. Vectorized.
% Version: 2 Feb 98
% Useage:  rad=sec2rad(sec)
% Input:   sec - vector of angles in seconds of arc
% Output:  rad - vector of angles in radians

% Copyright (c) 2011, Michael R. Craymer
% All rights reserved.
% Email: mike@craymer.com

rad=sec.*pi./180./3600;
