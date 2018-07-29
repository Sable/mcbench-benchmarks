function [b,e] = errorbarbar(x,y,E,barSettings,lineSettings)
% function to plot bar plots with error bars
%   [b,e] = errorbarbar(y,E)
%   [b,e] = errorbarbar(x,y,E)
%   [b,e] = errorbarbar(x,y,E, barSetings, lineSettings)
% Inputs barSettings and lineSettings are cells containing settings for
% bars and lineSettings. If you want to set only one of them, set the other
% to empty.
% Outputs b and e are the handles to the bar and the errorbar plotted.
% 
% NOTE: Currently does NOT support errorbar(x,y,L,U) directly. It is 
% possible as a trick using lineSettings appropriately.
% 
%  See Also:
%       bar, errorbar
% 
%  Dependencies:
%       No additional files are required.
% 

% Created by Venn on 2009-JUL-13 (vennjr@u.northwestern.edu)
% Modified:
%   2011-Jun-22. Removed the legends for the error bars.
%   2009-Jul-15. Now works with stacked bars too. Woot!
%   2009-Jul-14. Fixed minor bug in the input settings and fixed a bug when
%                either barSettings or lineSettings are empty.

%% use the appropriate setting
if nargin<5 || isempty(lineSettings)
    lineSettings = {'linestyle','none'};
end
if nargin<4
    barSettings = {};
end

%% plot the bars
if nargin<3 % if no x is provided
    b = bar(x);
    E = y;
    y = x;
else
    b = bar(x,y,barSettings{:});
end

%% get the xdata to plot the error plots
c = get(b,'Children');
if iscell(c)
    for i = 1:length(c)
        xdata(:,i) = mean(get(c{i},'xdata'));
        tempYData  = get(c{i},'ydata');
        ydata(:,i) = mean(tempYData(2:3,:))';
    end
else
    xdata = mean(get(c,'xdata'));
    tempYData  = get(c,'ydata');
    ydata = mean(tempYData(2:3,:))';
end

%% plot the errorbars
hold on;
e = errorbar(xdata,ydata,E,lineSettings{:});
for i = 1:length(e)
    hasbehavior(e(i), 'legend', false);
end
hold off;