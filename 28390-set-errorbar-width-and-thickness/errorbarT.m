function errorbarT(h,w,t,xtype)
%errorbarT Adjust the width and thickness of errorbars
%   errorbarT(H,W,T) adjust the width of error bars with handle H.
%      The input W is given in the units of the current x-axis.
%      The input T is the 'LineWidth' of the errorbar
%   errorbarT(H,W,T, 'RATIO') adjust the width of error bars with handle H.
%      As above, except:    
%      The input W is given as a ratio of X axis length (1/W). The result 
%      is independent of the x-axis units. A ratio between 20 and 80 is usually fine.
%    
%
%   See also ERRORBAR
%
% updated version:
% Alan Robinson, 8-4-2010
% MATLAB version: R2007a
%
% original version: errorbar_tick
% Author: Arnaud Laurent
% Creation : Jan 29th 2009
% MATLAB version: R2007a
%
% Notes: This function was created from a post on the french forum :
% http://www.developpez.net/forums/f148/environnements-developpement/matlab/
% Author : Jerome Briot (Dut) 
%   http://www.mathworks.com/matlabcentral/newsreader/author/94805
%   http://www.developpez.net/forums/u125006/dut/
% It was further modified by Arnaud Laurent and Jerome Briot.

% Check numbers of arguments
error(nargchk(1,4,nargin))

% Check for the use of V6 flag ( even if it is depreciated ;) )
flagtype = get(h,'type');

% Check number of arguments and provide missing values
if nargin==1
	w = 80;
end

if nargin<4
   xtype = 'units';
end

% Calculate width of error bars
if ~strcmpi(xtype,'units')
    dx = diff(get(gca,'XLim'));	% Retrieve x limits from current axis
    w = dx/w;                   % Errorbar width
end

% Plot error bars
if strcmpi(flagtype,'hggroup') % ERRORBAR(...)
    
    hh=get(h,'children');		% Retrieve info from errorbar plot
    x = get(hh(2),'xdata');		% Get xdata from errorbar plot
    
    x(4:9:end) = x(1:9:end)-w/2;	% Change xdata with respect to ratio
    x(7:9:end) = x(1:9:end)-w/2;
    x(5:9:end) = x(1:9:end)+w/2;
    x(8:9:end) = x(1:9:end)+w/2;

    set(hh(2),'xdata',x(:))	% Change error bars on the figure
    set(hh(2), 'LineWidth', t);
    
else  % ERRORBAR('V6',...) %ALAN: seems like these two could be combined...
    
    x = get(h(1),'xdata');		% Get xdata from errorbar plot
    
    x(4:9:end) = x(1:9:end)-w/2;	% Change xdata with respect to the chosen ratio
    x(7:9:end) = x(1:9:end)-w/2;
    x(5:9:end) = x(1:9:end)+w/2;
    x(8:9:end) = x(1:9:end)+w/2;

    set(h(1),'xdata',x(:))	% Change error bars on the figure
    set(h(1), 'LineWidth', t);
end
