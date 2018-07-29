function FLAM = fflaminar(RE)
% FFLAMINAR skin friction factor
%  FFLAMINAR(RE) returns the skin friction loss coefficient
%  for laminar flows in smooth pipes (Reynnolds number < 2300)
%  CALLED FUNCTION: none
%   Required Inputs are: 
%    RE  - Reynolds number (-)
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

format long g;                  % set the format of the calculations

if (RE>2300)
   error('The Reynolds number for laminar pipe flows must be less than 2300')
end

%calculate the skin friction factor for laminer flow in pipes
FLAM=64/RE;

return                          %end of the function
% -------------- end of the function ----------------------
