function [volume,area] = testTriangulationVolume(TRI,X,Y,Z)
%[VOLUME,AREA] = testTriangulationVolume(TRI,X,Y,Z)
%
%
%Copyright © 2001-2007, Jeroen P.A. Verbunt - Amsterdam, The Netherlands

%====================================================================================================
% © 2001-2007, Jeroen P.A. Verbunt - Amsterdam, The Netherlands
%
% History
%
% Who	When        What
%
% JPAV    29.01.2001  Creation (Jeroen P.A. Verbunt) (V0.0)
% JPAV    30.01.2001  Finished (V1.0)
% JPAV    06.06.2007  Published on Matlab File Exchnage
%
%====================================================================================================

APPNAME = 'testTriangulationVolume';
VERSION = '1.0';
DATE    = '30 January 2001';
AUTHOR  = 'Jeroen P.A. Verbunt';

% Define a volume consisting of four points:
% (0,0,0), (1,0,0), (0,1,0) and (0,0,1).
X = [0 1 0 0];
Y = [0 0 1 0];
Z = [0 0 0 1];

% Create triangulation of this volume. 
% Mind you: all normal vectors point outwards.
TRI = [3 2 1; 1 2 4; 4 3 1; 2 3 4];

% Compute volume and area
[volume,area] = triangulationVolume(TRI,X,Y,Z)

% Result:
% volume = 0.1667    = (1/3) x (1/2)
% area = 2.3660      = [3 x 1/2 (1 x 1)] + [1/2 x (sqrt(2) x sqrt(3/2))]
%
%= testTriangulationVolume=========================================================================
