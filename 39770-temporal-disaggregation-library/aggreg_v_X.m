function [c] = aggreg_v_X(op1,sc)
% PURPOSE: Generate a temporal aggregation vector (Extended version)
% ------------------------------------------------------------
% SYNTAX: c=aggreg_v_X(op1,sc);
% ------------------------------------------------------------
% OUTPUT: c: 1 x sc temporal aggregation vector
% ------------------------------------------------------------
% INPUT:  op1: type of temporal aggregation 
%         op1 = -1 ---> average (index)
%         op1 =  0 ---> sum (flow)
%         op1 =  h ---> interpolates at h element 
%                e.g. h=sc is stock at end of low-freq. period
%         sc: number of high frequency data points 
%            for each low frequency data points (freq. conversion)
% ------------------------------------------------------------
% LIBRARY:
% ------------------------------------------------------------
% SEE ALSO: aggreg_v
% ------------------------------------------------------------
% NOTE: The proper use of this function requires sometimes to
% adapt the calling function. Example: sw() interpolates according
% to op1 ==> sw() must be changed to handle aggreg_v_X() properly.

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Competitiveness
%  <enrique.quilis@mineco.es>

% Version 1.1 [November 2006]

% ------------------------------------------------------------
% Generation of aggregation vector c

if ((op1 < -1) | (op1 > sc))
       error ('*** IMPROPER TYPE OF TEMPORAL DISAGGREGATION ***');
end

switch op1
case -1   
   c = ones(1,sc)./sc;
case 0
   c = ones(1,sc);
otherwise
   c = zeros(1,sc);
   c(op1) = 1;
end
