% RAINFLOW cycle counting.
%   RAINFLOW counting function allows you to extract 
%   cycle from random loading.
%
% SYNTAX
%   rf = RAINFLOW(ext)
%   rf = RAINFLOW(ext, dt)
%   rf = RAINFLOW(ext, extt)
%
% OUTPUT
%   rf - rainflow cycles: matrix 3xn or 5xn dependend on input,
%     rf(1,:) Cycles amplitude,
%     rf(2,:) Cycles mean value,
%     rf(3,:) Number of cycles (0.5 or 1.0),
%     rf(4,:) Begining time (when input includes dt or extt data),
%     rf(5,:) Cycle period (when input includes dt or extt data),
%
% INPUT
%   ext  - signal points, vector nx1, ONLY TURNING POINTS!,
%   dt   - sampling time, positive number, when the turning points
%          spaced equally,
%   extt - signal time, vector nx1, exact time of occurrence of turning points.
%
%
%   See also SIG2EXT, RFHIST, RFMATRIX, RFPDF3D.

%   RAINFLOW
%   Copyright (c) 1999-2002 by Adam Nieslony,
%   MEX function.

