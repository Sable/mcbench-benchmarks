function XVW = X_vw(X,XOSV)
% X_vw  Vapour Weight Quality
% X_vw(X,XOSV) Returns the Vapour Weight Quality. 
% The local quality is slightly higher than the 
% cross sectional average thermodynamic quality
% obtained from heat balance.  It's value depends
% on the onset of significant void
%  Called function: NONE 
%  Required Inputs are: 
%   X is the local thermodynamic quality in fractions
%   X_osv is the onset of significant void in fractions
%   X_vw is returned in fractions
% ---------------------------------------------------------------
% The MATLAB function was created by Tibor Balint, December 1998
% TBoreal Research Corporation, Toronto, Ont. Canada 
% (tibor@netcom.ca) and also, University of Warwick, UK
% ---------------------------------------------------------------

format long g;  % set the format of the calculations

if X<XOSV
   error('The function is not applicable when X_local < X_osv')
end


% Calculate the Vapour Weight Quality
XVW=(X-XOSV*exp((X/XOSV)-1))/(1-XOSV*exp((X/XOSV)-1));

return     