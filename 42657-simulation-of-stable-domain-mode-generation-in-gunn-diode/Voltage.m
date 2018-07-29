%% Ideal voltage source with trapezium pulse form
% U0 - maximum value [V], 
% t1, t2, t3 - rise time, on time and fall time of the pulse [s],
% t - current time [s]
function [out_vol] = Voltage(U0, t1, t2, t3, t)

out_vol = ((t>=0) & (t<t1)).*U0.*t/t1 + ((t>=t1) & (t<(t1+t2))).*U0 ...
        + ((t>=t1+t2) & (t<t1+t2+t3)).*(U0*(t2+t1-t)/t3 + U0);
