% Test script for the legendlinestyles.m function

% Problem: Two functions, sampled in 1024 point and the goal is to plot
% them using markers.
% 
% If the functions are plotted with markers directly, the dense sampling
% causes the plot to look bad. If the markers are plotted separately, the
% legend does not use correct line styles.
%
% The legendlinestyles.m attemts to correct this.

clc
clf
close all

% Create plot
t = linspace(0,2*pi,1024);
t2 = linspace(0,2*pi,30);
x1 = cos(t);  % 1024 points
xx1 = cos(t2); % 30 points (for markers)

x2 = cos(4*t); % 1024 points
xx2 = cos(4*t2); % 30 points (for markers)

% Plot originial (smooth) lines first, then the markers.
plot(t,x1,'black-',t,x2,'black-',t2,xx1,'blackd',t2,xx2,'blacks');
xlabel('t');
ylabel('x(t)');
axis tight;

% Call legend, only supplying names for the "smooth lines", in this case
% two of them.
    
h = legend('x_1(t) = cos(t)', 'x_2(t) = cos(4t)',-1);


% Define new markers (and linestyles, optional)
markers = {'d','s'};
linestyles = {'-','-'};
linecolors = {[0 0 1],'red'};

%==========================================================================
% Call legendlinestyles in either of the following ways
%==========================================================================

% Add markers but leave line styles and colors unchanged
legendlinestyles(h, markers);

% Change markers and linestyles but leave colors unchanged
%legendlinestyles(h, markers,linestyles);

% Add linestyles and markers and change colors
%legendlinestyles(h, markers,linestyles,linecolors);

% Change line styles and colors, but don't add markers
%legendlinestyles(h, {},linestyles,linecolors);

% Add markers and change colors, but leave line styles unchanged
%legendlinestyles(h, markers,{},linecolors);

% Change legend color but leave line styles and markers unchanged
%legendlinestyles(h, {},{},linecolors);