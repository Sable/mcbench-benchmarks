function [out]=f_x(m0, m1, in);
out=m1*in + 0.5*(m0-m1).*(abs(in+1)-abs(in-1));