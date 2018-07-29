%% Test suite for Minimum bounding objects: RECT, CIRCLE, SPHERE, ELLIPSE

%% Minimal area rectangle around random data

% Random points in the unit square
x = rand(1000,1);
y = rand(1000,1);

% should have a nearly square bounding rectangle
tic,[xrect,yrect] = minboundrect(x,y),toc

% 
plot(x,y,'ro',xrect,yrect,'b-')

%% Minimal circle around (normally distributed) random data
x = randn(100000,1);
y = randn(100000,1);

% It should have a center of roughly (0,0). 
tic,[center,radius] = minboundcircle(x,y),toc

theta = linspace(0,2*pi,100);
xc = center(1) + radius*cos(theta);
yc = center(2) + radius*sin(theta);

% The circle will generally pass exactly through
% three of the points.
plot(x,y,'ro',xc,yc,'b-')

%% Minimal circle around nearly linear data.
x = rand(5,1);
y = x + (rand(size(x))-.5)/10;

[center,radius] = minboundcircle(x,y)

theta = linspace(0,2*pi,100);
xc = center(1) + radius*cos(theta);
yc = center(2) + radius*sin(theta);

% Sometimes the minimal radius circle may pass
% through only two points.
plot(x,y,'ro',xc,yc,'b-')
axis equal

%% Degenerate cases - a minimal circle around exactly two points
x = [0 1];
y = x;

[center,radius] = minboundcircle(x,y)

%% Degenerate cases - a minimal circle around exactly one point
x = 1;
y = 2;

% The radius must be zero
[center,radius] = minboundcircle(x,y)

%% Minimum radius sphere around random data
xyz = rand(10000,3);

% The sphere should have approximate center [.5 .5 .5]
% and approximate radius sqrt(3)/2 = .86603...
[center,radius] = minboundsphere(xyz)

%% Minimum area ellipse around exactly circular data
theta = linspace(0,2*pi,100);
x = cos(theta);
y = sin(theta);

% will have center == [0,0], radius = 1, both to within
% double precision accuracy in Matlab.
[center,H,xe,ye] = minboundellipse(x,y)

plot(x,y,'ro',xe,ye,'b-')
axis equal

%% Minimum area ellipse around correlated data
xy = randn(100,2);
xy = xy*rand(2)^2;

% will have center [0,0], radius = 1, both to within
% double precision accuracy in Matlab.
[center,H,xe,ye] = minboundellipse(xy(:,1),xy(:,2))

plot(xy(:,1),xy(:,2),'ro',xe,ye,'b-')
axis equal

%% 
