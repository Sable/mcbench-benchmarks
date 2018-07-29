function FRHF = ffrough(RE, DH, ERH)
% FFROUGH skin friction factor
%  FFROUGH(RE, DH, ERH) returns the skin friction loss coefficient
%  for laminar, turbulent and transitional flows in rough pipes 
%  For the full range of Reynnolds numbers
%  CALLED FUNCTION: none
%   Required Inputs are: 
%    RE  - Reynolds number (-)
%    DH  - Hydralulic diameter (m)
%    ERH - Equivalent roughness height (m)
%          (e.g 1.5um -> use 0.0000015)
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------
format long g;                  % set the format of the calculations

if RE<=2300
  %calculate the skin friction factor for laminer flows in pipes
  FRHF=64/RE;
elseif and((RE>2300),(RE<4000))
   LB=64/2300;  %set the lower bound for the transitional zone
   UB=ffcw(4000, DH, ERH); %set the upper bound for the transitional zone
   RR=4000-2300;  %set the Reynolds range for the transitional zone
   RD=RE-2300;    %get the Reynolds number above the laminar range
   
   FLOC=RD*(UB-LB)/RR; %calculate the ff above the laminar ff at Re=2300
   FRHF=LB+FLOC;   %the skin friction factor in the transitional zone
elseif RE>=4000
  %call the Colebrook-White friction factor
  FRHF=ffcw(RE, DH, ERH);
end

return    %end of the function
% -------------- end of the function ----------------------
