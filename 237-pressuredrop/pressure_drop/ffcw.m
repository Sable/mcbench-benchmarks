function FCW = ffcw(RE, DH, ERH)
% FFCW Colebrook-White friction factor
%  FFCW(RE,DH,ERH) returns the friction factor
%  using the iterative Colebrook-White correlation. 
%  The correlation gives friction factor predictions
%  for both transitional and fully developed turbulent
%  flows at Reynolds numbers above 4000
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
if (RE<4000)
   error('The Reynolds number must be greater than 4000')
end

FGUESS=0.0175;                  %set the initial guess
for J=1:30                      %begining of the iteration loop
 FCW=1.0/((-2*log10((ERH/(DH*3.7))+2.51/((FGUESS^0.5)*RE)))^2);
   if (abs(FCW-FGUESS)<0.0001)  %set the acceptance criteria
    return
   end   
 FGUESS =FCW;
end                             %end of the for loop

%gives warning messages in command window and in a dialog box
error('COULD NOT CONVERGE ON FRICTION FACTOR ITERATION - check the inputs')

return                          %end of the function
% -------------- end of the function ----------------------
