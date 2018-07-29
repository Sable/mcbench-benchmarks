function [out]=W_w(a, b, in);
if abs(in) < 1 
   out = a;
end
%
if abs(in) > 1 
   out = b;
end