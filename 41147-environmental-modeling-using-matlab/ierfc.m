function y = ierfc (x)
%ERF Error function.
%   Y = IERFC(X) is the integral error function for each element of X.  
%   X must be real. The integral error function is defined as:
%
%     ierfc(x) = exp(-x*x)/sqrt(pi) - x*erfc(x)
%
%   Class support for input X:
%      float: double, single
%
%   See also ERF, ERFC.

%   Ref: Abramowitz & Stegun, Handbook of Mathematical Functions, sec. 7.1.

%   $Ekkehard Holzbecher  $Date: 2006/02/04 $

y = -x*erfc(x) + exp(-x*x)/sqrt(pi);