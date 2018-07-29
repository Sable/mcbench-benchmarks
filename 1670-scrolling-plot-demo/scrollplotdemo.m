function scrollplotdemo

% Created by Steven Lord, slord@mathworks.com
% Uploaded to MATLAB Central
% http://www.mathworks.com/matlabcentral
% 7 May 2002
%
% Permission is granted to adapt this code for your own use.
% However, if it is reposted this message must be intact.

% Generate and plot data
x=0:1e-2:2*pi;
y=sin(x);
dx=2;
%% dx is the width of the axis 'window'
a=gca;
p=plot(x,y);

% Set appropriate axis limits and settings
set(gcf,'doublebuffer','on');
%% This avoids flickering when updating the axis
set(a,'xlim',[0 dx]);
set(a,'ylim',[min(y) max(y)]);

% Generate constants for use in uicontrol initialization
pos=get(a,'position');
Newpos=[pos(1) pos(2)-0.1 pos(3) 0.05];
%% This will create a slider which is just underneath the axis
%% but still leaves room for the axis labels above the slider
xmax=max(x);
S=['set(gca,''xlim'',get(gcbo,''value'')+[0 ' num2str(dx) '])'];
%% Setting up callback string to modify XLim of axis (gca)
%% based on the position of the slider (gcbo)

% Creating Uicontrol
h=uicontrol('style','slider',...
    'units','normalized','position',Newpos,...
    'callback',S,'min',0,'max',xmax-dx);