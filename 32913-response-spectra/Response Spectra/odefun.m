function ydot = odefun(t,y,xi,Tn,t1,a2)

a = interp1(t1,a2,t); % Interpolate the data set (t1,a2) at time t

ydot = [y(2); -(4*pi*xi/Tn)*y(2)-(2*pi/Tn)^2*y(1)- a];