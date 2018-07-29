function [ F ] = myfunc( str )
% Function to be MINIMIZED
% By Kyriakos Tsourapas
% You may contact me through the Mathworks site
% University of Essex 2002


[x, y] = myconvert( str );
F = 100 * (x^2 - y)^2 + (1 - x)^2;

%F = x^2 + y^2;
