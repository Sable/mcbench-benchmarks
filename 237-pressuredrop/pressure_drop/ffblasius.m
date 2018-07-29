function FBL = ffblasius(RE)
% FFBLASIUS Blasius skin friction factor
%  FFCW(RE) returns the skin friction loss coefficient
%  using the Blasius correlation. 
%  CALLED FUNCTION: none
%   Required Inputs are: 
%    RE  - Reynolds number (-)
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

format long g;                  % set the format of the calculations

if or((RE<4000),(RE>100000))
   error('The valid Reynolds number range is (4000 < RE < 100000)')
end


%set the correlation constants
a=0.3164;
b=-0.25;

%calculate the Blasius skin friction factor
FBL=a*RE^b;

return                          %end of the function
% -------------- end of the function ----------------------
