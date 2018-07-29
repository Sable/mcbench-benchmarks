function [out]=f_x_CNN(in);
out=0.5*(abs(in+1)-abs(in-1));