function output = hex2bin (input)
% Converts a 8-bit Hex number string to 32-bit binary number string
% Hex number must be of the following form
%       input = [ '67','45','23','01']

byte1 = dec2bin(hex2dec(input(7:8)));
byte2 = dec2bin(hex2dec(input(5:6)));
byte3 = dec2bin(hex2dec(input(3:4)));
byte4 = dec2bin(hex2dec(input(1:2)));
       
output_char = [ num2str(zeros(8-length(byte4),1) )',  byte4 ... 
                num2str(zeros(8-length(byte3),1) )',  byte3 ... 
                num2str(zeros(8-length(byte2),1) )',  byte2 ... 
                num2str(zeros(8-length(byte1),1) )',  byte1 ] ;

output= str2num(output_char')';