function FSM = ffsmooth(RE)
% FFSMOOTH skin friction factor
%  FFSMOOTH(RE) returns the skin friction loss coefficient
%  for laminar, turbulent and transitional flows in smooth pipes 
%  For Reynnolds numbers up to 100000
%  CALLED FUNCTION: none
%   Required Inputs are: 
%    RE  - Reynolds number (-)
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

format long g;                  % set the format of the calculations

if RE<=2300
  %calculate the skin friction factor for laminer flows in pipes
  FSM=64/RE;
elseif and((RE>2300),(RE<4000))
   LB=64/2300;  %set the lower bound for the transitional zone
   UB=0.3164*4000^(-0.25); %set the upper bound for the transitional zone
   RR=4000-2300;  %set the Reynolds range for the transitional zone
   RD=RE-2300;    %get the Reynolds number above the laminar range
   
   FLOC=RD*(UB-LB)/RR; %calculate the ff above the laminar ff at Re=2300
   FSM=LB+FLOC;   %the skin friction factor in the transitional zone
elseif and((RE>=4000),(RE<=100000))
 %set the correlation constants
  a=0.3164;
  b=-0.25;
  %calculate the Blasius skin friction factor
  FSM=a*RE^b;
else  
   % error if the Reynolds number is above 100000
   error('The function calculates friction factors up to Re=100000')
end





return                          %end of the function
% -------------- end of the function ----------------------
