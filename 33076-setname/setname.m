function setname(ax)
%SETNAME sets the figure name to equal the figure title.
%   With many figure windows open, SETNAME makes it easier to disinguish
%      which is which in the taskbar.
%   SETNAME(AX) uses the axis AX instead of the current axis.
%   If the figure has no title, SETNAME uses the axis labels instead.
%
%   I also put the following in my STARTUP file to turn off the default figure numbering:
%      set(0,'defaultfigurenumbertitle','off')
%
%   Example:
%      figure,plot(rand(100,1)),title('random numbers'),setname
%
%   Written by Andy Bliss 2008.

if nargin==0
    ax=gca;
end
%get the figure title
name=get(get(ax,'Title'),'String');
%if plot has no title, use x and y-labels instead
if isempty(name)
    xname=get(get(ax,'XLabel'),'String');
    xname=sscanf(xname,'%[^(] %*[^)] %*1s %s'); %get rid of text between parenthesis (like units)
    yname=get(get(ax,'YLabel'),'String');
    yname=sscanf(yname,'%[^(] %*[^)] %*1s %s'); %get rid of text between parenthesis (like units)
    name=[yname ' vs ' xname];
end
%set the figure name
set(get(ax,'parent'),'Name',name)

