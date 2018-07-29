function y=getmondim(mnum)
% y = getmondim(monitornumber)  GET MONitor DIMensions.
%   "y" is the dimensions of the specified monitor represented as
%   [xstart,ystart,width,height] where values are in pixels.
%   (xstart,ystart) are the absolute coordinates of the lower left corner.
%   "monitornumber" is a number associated with each monitor (Default=1).
%       Monitor numbering is defined as the row number of the corresponding 
%       monitor in the root property 'MonitorPositions'. 
%   Examples: 
%       y=getmondim; y=getmondim(2);

%   Copyright 2006 Mirtech, Inc.
%   created 09/26/2006  by Mirko Hrovat on Matlab Ver. 7.2
%   Mirtech, Inc.       email: mhrovat@email.com
%  Notes:
%       The primary monitor is always numbered 1 and always starts at (1,1).
%   'MonitorPositions' returns coordinates corresponding to the upper left
%   corner and the bottom right corner (Windows convention). Matlab 'Help'
%   on this property is incorrect. GETMONDIM converts these coordinates to
%   the Matlab convention where the lower left corner starts at (1,1).
%       There is a bug with the root property 'ScreenSize'. If the primary
%   monitor's resolution is adjusted after Matlab has started, then the
%   size parameters of 'ScreenSize' are not adjusted while the origin is
%   adjusted. GETMONDIM.M fixes this be using the 'ScreenSize' origin to 
%   correct for the discrepancy. Note that on restarting Matlab the
%   'ScreenSize' property changes to the correct values!

if nargin==0,       mnum=[];    end        
if isempty(mnum),   mnum=1;     end
savedunits=get(0,'Units');
set(0,'Units','pixels')         % make sure unit values are in pixels
mpos=get(0,'MonitorPositions'); % get list of monitor positions
% MonitorPositions are the coordinates for upper left & lower right corners.
primaryhght=mpos(1,4)-mpos(1,2)+1;
if any(mnum==1:size(mpos,1)),
    % need to convert MonitorPositions to Matlab convention.
    height=mpos(mnum,4)-mpos(mnum,2)+1;
    width=mpos(mnum,3)-mpos(mnum,1)+1;
    offset=1;       %#ok
% NOTE!
% Bugfix for the root property 'ScreenSize' in case the primary monitor's
% resolution has changed. If bug is ever fixed then delete these lines.
    screenxy=get(0,'ScreenSize');
    offset=2-screenxy(2);
% end bugfix
    
    % get lower left corner coordinates
    llpt=[mpos(mnum,1),primaryhght-mpos(mnum,4)+offset];  
    y=[llpt,width,height];
else
    warning('  Monitor does not exist!');   %#ok
    y=[];
end
set(0,'Units',savedunits)
