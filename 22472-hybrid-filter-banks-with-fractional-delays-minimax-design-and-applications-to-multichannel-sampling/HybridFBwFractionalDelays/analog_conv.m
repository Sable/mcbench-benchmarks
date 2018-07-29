function y = analog_conv(I, sys, f, t, dt)

% analog_conv: simulate an analog system. Input and output will be given as
% an array of values at equi-distance time interval.
% 
% Usage: y = analog_conv(x, sys, f, t, dt)
%
% INPUTS:
%       I: effective time interval will be used in the output
%       sys: the analog system
%       f: the input signal
%       t: discrete instances used in the simulation
%       dt: time increment
%
% OUTPUT:
%       y: output signal
%
% See also: demo

a = lsim(sys, f, t);
n = round(I/dt);

for i = 1:length(n)
    if (n(i) < 1)
        y(i) = 0;
    else
        y(i) = a(n(i));
    end
end

