function [ num1, num2 ] = myconvert( str )
% Function to convert the vector string to numbers
% By Kyriakos Tsourapas
% You may contact me through the Mathworks site
% University of Essex 2002


% CREATE THE NUMBERS FROM THE STRING
sign1    = str(1);
intpart1 = sprintf('%d%d', str(2:3));
decpart1 = sprintf('%d%d%d%d%d%d%d%d%d%d', str(4:13));
sign2    = str(14);
intpart2 = sprintf('%d%d', str(15:16));
decpart2 = sprintf('%d%d%d%d%d%d%d%d%d%d', str(17:26));

% CONVERT THEM TO DECIMAL FROM BINARY
num1 = bin2dec(intpart1) + bin2dec(decpart1)/1000;
num2 = bin2dec(intpart2) + bin2dec(decpart2)/1000;

if sign1 == 1
    num1 = - num1;
end

if sign2 == 1
    num2 = - num2;
end