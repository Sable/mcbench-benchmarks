function output = bin2dec2(input)
% Converts a 32-bit bin number to 32-bit binary string
% Bin number must be of the following form
%       input = [ 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 ... 
%                 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 ]
output = bin2dec(num2str(input')');