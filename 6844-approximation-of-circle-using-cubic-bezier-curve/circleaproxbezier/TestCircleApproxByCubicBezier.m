clc
clear
hold on

n=100;          % number of intervals (i.e. parametric curve would be evaluted n+1 times)
k=0.5522847498; % kappa (See documentation how this value is obtained)

% First Quadrant
Px=[1 1 k 0];	
Py=[0 k 1 1];

PlotBezier1(Px,Py,n);

% Second Quadrant
Px=[0 -k -1 -1];	
Py=[1  1  k  0];
PlotBezier1(Px,Py,n)

% Third Quadrant
Px=[-1 -1 -k  0];	
Py=[ 0 -k -1 -1];
PlotBezier1(Px,Py,n)

% Fourth Quadrant 
Px=[ 0  k  1 1];	
Py=[-1 -1 -k 0];
PlotBezier1(Px,Py,n)

title('Approximation of Circle using Cubic Bezier');

hold off

% % % --------------------------------
% % % Author: Dr. Murtaza Khan
% % % Email : drkhanmurtaza@gmail.com
% % % --------------------------------