function [c]=aggreg_v(op1,sc)
% PURPOSE: Generate a temporal aggregation vector
% ------------------------------------------------------------
% SYNTAX: c=aggreg_v(op1,sc);
% ------------------------------------------------------------
% OUTPUT: c: 1xsc temporal aggregation vector
% ------------------------------------------------------------
% INPUT:  op1: type of temporal aggregation 
%         op1=1 ---> sum (flow)
%         op1=2 ---> average (index)
%         op1=3 ---> last element (stock) ---> interpolation
%         op1=4 ---> first element (stock) ---> interpolation
%         sc: number of high frequency data points 
%            for each low frequency data points (freq. conversion)
% ------------------------------------------------------------
% LIBRARY:
% ------------------------------------------------------------
% SEE ALSO: aggreg, temporal_agg, aggreg_v_X

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Finance
%  Paseo de la Castellana, 162. Office 2.5-1.
%  28046 - Madrid (SPAIN)
%  <enrique.quilis@meh.es>

% Version 1.1 [August 2006]

% ------------------------------------------------------------
% Generation of aggregation vector c

switch op1
case 1   
   c=ones(1,sc);
case 2
   c=ones(1,sc)./sc;
case 3
   c=zeros(1,sc);
   c(sc)=1;
case 4
   c=zeros(1,sc);
   c(1)=1;
otherwise
   error ('*** IMPROPER TYPE OF TEMPORAL DISAGGREGATION ***');
end
