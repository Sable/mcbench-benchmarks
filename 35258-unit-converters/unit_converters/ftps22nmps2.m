function [nmps2] = ftps22nmps2(ftps2)
% Convert acceleration from feet per square-second to nanometers per second
% squared.
% Chad A. Greene 2012
nmps2 = ftps2*304800000; 
end