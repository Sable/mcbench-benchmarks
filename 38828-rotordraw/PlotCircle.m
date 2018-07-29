%% "Spirograph" Code
%  Jonathan Jamieson - September 2013
%  unigamer@gmail.com
%  www.jonathanjamieson.com

function PlotCircle(xc, yc, r)
t = 0 : .1 : 2*pi+0.2;
x = r * cos(t) + xc;
y = r * sin(t) + yc;
plot(x, y)
