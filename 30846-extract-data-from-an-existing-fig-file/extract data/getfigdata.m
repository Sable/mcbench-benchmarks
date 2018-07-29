function [xdata,ydata,zdata]=getfigdata(figure_name);
%getfigdata is a simple m file to get back the data from a 2D or 3D figure
% In case of 2D figures, discard zdata
% Example:
%    get the data from the figure and then 
%    recheck if you got the data by opening the original figure and
%    plotting the extracted data on top of it:
% [xdata,ydata,zdata]=getfigdata('test.fig');
% hold on
%plot(xdata,ydata,'r')
fighandle=openfig(figure_name);
ax=findall(fighandle,'Type','line');
xdata=get(ax,'Xdata');
ydata=get(ax,'YData');
zdata=get(ax,'ZData');

