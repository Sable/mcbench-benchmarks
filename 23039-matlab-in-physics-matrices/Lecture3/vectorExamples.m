function vectorExamples
% example to plot different types of vector data
%figure('color',[1 1 1])
% A timeseries plot of sunspot activity
subplot(2,2,1)
load sunspot.dat
year=sunspot(:,1);
relNums=sunspot(:,2);
plot(year,relNums)
title('Sunspot Data'), grid on, xlabel('Years')

% a plot of motor noise vs rpm 
conn = database('Motor Noise','','');
setdbprefs('DataReturnFormat','numeric')
curs = exec(conn,'select * from OriginalMotor7000');
% Get data and release resource
data=fetch(curs);
data1=data.Data;
rpm = data1(:,1);
OriginalMotor = data1(:,2);
subplot(2,2,2)
plot(rpm,OriginalMotor)
title('Motor noise vs RPM')
xlabel('RPM'), grid on

% sampling from a function
subplot(2,2,3)
x = linspace(0,3,200);
fx=sin(exp(x));
plot(x,fx,'r-.'); hold on
% sample randomly from f(x)
xc = sort(rand(1,30)*3);
yc = sin(exp(xc));
stem(xc,yc), grid on, hold off
title('Sampling from an unknown function')

% plotting a series of points in 3-space
subplot(2,2,4)
plot3(1,1,1,'^')
hold on
line([0 1],[0 1],[0 1])
line([0 -1],[0 1],[0 1],'color',[1 0 0])
plot3(-1,1,1,'r^')
line([0 1],[0 1],[0 -1],'color',[0 0.5 0.5])
plot3(1,1,-1,'^','color',[0 0.5 0.5])
plot3(1,-1,1,'^','color',[0 0.5 0])
line([0 1],[0 -1],[0 1],'color',[0 0.5 0])
plot3(0,0,0,'ko')
box on, grid on, view([-31.5 8]), hold off
title('Co-ordinates in 3-space')

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 35 $  $Date: 2009-05-29 15:27:34 +0100 (Fri, 29 May 2009) $
