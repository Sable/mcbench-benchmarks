%model_system.m

% Copyright 2003-2010 The MathWorks, Inc.

%data set
v = th;                         %angular rotation of pendulum over time
u = ones(size(th));             %continuous steady-state ambient operation
sysData = iddata(v,u,1/fps)

%discrete time system model (ie, difference equation representation)
nPoles = 2;
nZeros = 1;
nDelays = 0;
Hz = arx(sysData,[nPoles nZeros nDelays])   %transfer function

%continuous time representation
Hs = d2c(Hz)
poles = roots(Hs.a)
Wn = abs(imag(poles(1)))
Fn = Wn/2/pi
period = 1/Fn;
msg = sprintf('Period = %.3g sec',period);
title(msg)
disp(msg)