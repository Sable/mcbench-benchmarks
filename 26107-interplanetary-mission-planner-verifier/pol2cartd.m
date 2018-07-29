function [x,y,z] = pol2cartd(th,r,z)
%Embedded MATLAB Library function.

%   Original MATLAB version  L. Shure, 4-20-92.
%   Copyright 2002-2006 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $  $Date: 2006/10/10 02:20:31 $


x = r.*cosd(th);
y = r.*sind(th);
