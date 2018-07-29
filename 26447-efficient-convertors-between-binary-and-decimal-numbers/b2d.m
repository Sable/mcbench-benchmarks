function y = b2d(x)

% Convert a binary array to a decimal number
% 
% Similar to bin2dec but works with arrays instead of strings and is found to be 
% rather faster

z = 2.^(length(x)-1:-1:0);
y = sum(x.*z);
