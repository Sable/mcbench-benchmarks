function [y]=fseries(phi,t,T)
%
% this function generates a fourier series with a maximum of 4 harmonics
% t is a line vector corresponding to 1:365*Y, where Y is the number of
% years for the time series  to be generated.  T is the period = 365/(2*pi)
%
y=phi(1)+phi(2)*sin(t./T+phi(3))+phi(4)*sin(2*t./T+phi(5))...
   +phi(6)*sin(3*t./T+phi(7))+phi(8)*sin(4*t./T+phi(9));