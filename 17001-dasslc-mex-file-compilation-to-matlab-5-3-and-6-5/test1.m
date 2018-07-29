% Dasslc test problem
% requires files: dydt1.m

t0  = 0.0;        % initial value for independent variable
tf  = 1.0;        % final value for independent variable
y0  = [3 6 5]';   % initial state variables

[t,y]=dasslc('dydt1',[t0 tf],y0);
plot(t,y);
