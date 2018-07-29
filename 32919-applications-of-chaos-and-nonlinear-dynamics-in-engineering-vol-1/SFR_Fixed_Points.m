% SFR_Fixed_Points - Determine the fixed points for the SFR.
% Copyright Springer 2013 Stephen Lynch.
% Use the Data Cursor to locate the three fixed points.
hold on
axis([0 4 -4 4])
p1=ezplot('2.2+0.15*(x*cos(x^2+y^2)-y*sin(x^2+y^2))-x');
set(p1,'Color','b');	
p2=ezplot('0.15*(x*sin(x^2+y^2)+y*cos(x^2+y^2))-y');
set(p2,'Color','r');
hold off
title('Fixed Points of the SFR');
