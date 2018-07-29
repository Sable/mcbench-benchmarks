function [f1,f2] = DialedFrequencies(Number)

% Function to get DTMF frequencies for dialed number 
% Input Variables
%    Number = Dialed Number Range (0-16)
%             {Use 1 - 9   for Numbers "1"-"9"
%                  0       for Number "10"
%                  13      for Number "A"
%                  12      for Number "B"
%                  13      for Number "C"
%                  14      for Number "D"
%                  15      for Number "*"
%                  16      for Number "#"}
%
% Output Variables
%     f1  = Low Frequency related to dialed Number
%     f2  = High Frequency related to dialed Number
%
%    Rajiv Singla        DSP Final Project            Fall 2005
%=====================================================================

% Checking for minimum number of arguments
if nargin < 1
    error('Not enough input arguments');
end

rf=[697  770  852  941];   %DTMF Row frequencies
cf=[1209 1336 1477 1633];  %DTMF Column frequencies

switch Number
    case 1,         %Case one when Number "1" is pressed
        f1=rf(1);
        f2=cf(1);
    case 2,         %Case one when Number "2" is pressed
        f1=rf(1);
        f2=cf(2);
    case 3,         %Case one when Number "3" is pressed
        f1=rf(1);
        f2=cf(3);
    case 4,         %Case one when Number "4" is pressed
        f1=rf(2);
        f2=cf(1);
    case 5,         %Case one when Number "5" is pressed
        f1=rf(2);
        f2=cf(2);
    case 6,         %Case one when Number "6" is pressed
        f1=rf(2);
        f2=cf(3);
    case 7,         %Case one when Number "7" is pressed
        f1=rf(3);
        f2=cf(1);
    case 8,         %Case one when Number "8" is pressed
        f1=rf(3);
        f2=cf(2);
    case 9,         %Case one when Number "9" is pressed
        f1=rf(3);
        f2=cf(3);
    case 10,        %Case one when Number "10" is pressed
        f1=rf(4);
        f2=cf(2);
    case 11,        %Case one when Number "A" is pressed
        f1=rf(1);
        f2=cf(4);
    case 12,        %Case one when Number "B" is pressed
        f1=rf(2);
        f2=cf(4);
    case 13,        %Case one when Number "C" is pressed
        f1=rf(3);
        f2=cf(4);
    case 14,        %Case one when Number "D" is pressed
        f1=rf(4);
        f2=cf(4);
    case 15,        %Case one when Number "*" is pressed
        f1=rf(4);
        f2=cf(1);
    case 16,        %Case one when Number "#" is pressed
        f1=rf(4);
        f2=cf(3);    
    otherwise
        error('Invalid Input Number:Check function help page')
end
