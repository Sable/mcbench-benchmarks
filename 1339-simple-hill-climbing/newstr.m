function [ str2 ] = newstr( str, pos )
% Function to a new string by flipping a single bit
% By Kyriakos Tsourapas
% You may contact me through the Mathworks site
% University of Essex 2002

str2 = str;

% FLIP THE POSITION
if str2(pos) == 0
    str2(pos) = 1;
else
    str2(pos) = 0;
end