function newxy=screenxymon(monitor,xy)
% newxy = screenxymon(monitor,xy)  SCREEN X-Y MONitor coordinates.
%   Calculates relative screen coordinates for the monitor from the
%   absolute coordinates. This function simplifies the use of multiple monitors 
%   in Matlab through the use of relative coordinates for each monitor.
%   See also SCREENXYABS.M for calculation of absolute coordinates.
%   "newxy" is a vector of xy pairs (pixels) calculated for each input xy pair.
%   "monitor" is a number associated with each number (Default=1).
%       Monitor numbering is defined as the row number of the corresponding 
%       monitor in the root property 'MonitorPositions'. 
%   "xy" is a vector of absolute xy coordinate pairs (pixels) which are relative
%       to the lower left corner of the primary monitor (1,1).
%   Examples: 
%       y=screenxymon(2,[1,1]);  y=screenxymon(2,[1,1,1024,768]);

%   Copyright 2006 Mirtech, Inc.
%   created 09/27/2006  by Mirko Hrovat on Matlab Ver. 7.2
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
    newxy=reshape(xy-repmat([mpos(1)-1;mpos(2)-1],[1,xypairs]),xyformat);
end
