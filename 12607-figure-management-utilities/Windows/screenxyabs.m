function newxy=screenxyabs(monitor,xy)
% newxy = screenxyabs(monitor,xy)  SCREEN X-Y ABSolute coordinates.
%   Calculates absolute screen coordinates from the relative monitor screen
%   coordinates. This function simplifies the use of multiple monitors 
%   in Matlab through the use of relative coordinates for each monitor.
%   See also SCREENXYMON.M for calculation of relative coordinates.
%   "newxy" is a vector of xy pairs (pixels) calculated for each input xy pair.
%   "monitor" is a number associated with each number (Default=1).
%       Monitor numbering is defined as the row number of the corresponding 
%       monitor in the root property 'MonitorPositions'. 
%   "xy" is a vector of xy coordinate pairs (pixels) relative to the monitor's
%       origin (1,1) which is the coordinate of the monitor's lower left corner.
%   Examples: 
%       y=screenxyabs(2,[1,1]);  y=screenxyabs(2,[1,1,1024,768]);

%   Copyright 2006 Mirtech, Inc.
%   created 09/25/2006  by Mirko Hrovat on Matlab Ver. 7.2
%   Mirtech, Inc.       email: mhrovat@email.com
%   Uses getmondim.m

switch nargin
    case 2
    case 1
        xy=[];
    case 0
        monitor=[];
        xy=[];
    otherwise
        error ('  Too many arguments!')
end  % switch
if isempty(monitor),    monitor=1;  end
if isempty(xy),         xy=[1,1];   end
xypairs=fix(numel(xy)/2);
xyformat=size(xy);
xy=reshape(xy,[2,xypairs]);     % make each row correspond to a different xy pair
mpos=getmondim(monitor);        % get monitor's origin
if isempty(mpos),
    error ('  Monitor %g does not exist',monitor)
else
    newxy=reshape(xy+repmat([mpos(1)-1;mpos(2)-1],[1,xypairs]),xyformat);
end
