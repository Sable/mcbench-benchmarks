function [G] = nmps22G(nmps2)
% Convert acceleration from nanometers per square-second to accerations
% provided by Earths gravity.
% Chad A. Greene 2012
G = nmps2*1.019716213e-10; 