function [Xrls,yrls,s]=RLSreg(y,X)
%Syntax: [Xrls,yrls,s]=RLSreg(y,X)
%_______________________________
%
% Calculates the Reweighted Least Squares (RLS) regression data points
% and the scale parameter from the LMS regression.
%
% Xrls is the X values matrix to be taken into account for RLS.
% yrls is the y values vector to be taken into account for RLS.
% s is RLS scale parameter.
% y is the vector of the dependent variable.
% X is the data matrix of the independent variable.
%
% Reference:
% Rousseeuw PJ, Leroy AM (1987): Robust regression and outlier detection. Wiley.
%
%
% Alexandros Leontitsis
% Institute of Mathematics and Statistics
% University of Kent at Canterbury
% Canterbury
% Kent, CT2 7NF
% U.K.
%
% University e-mail: al10@ukc.ac.uk (until December 2002)
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421
%
% Sep 3, 2001.

if nargin<1 | isempty(y)==1
   error('Not enough input arguments.');
end

% Estimate the LMS values
if nargin<2 | isempty(X)==1
   LMSout=LMSreg(y);
   X=(1:length(y))';
else
   LMSout=LMSreg(y,X);
end

% p is the number of parameters to be estimated
p=size(X,2)+1;

% Calculate the residuals
r=y-LMSout;

% Estimate the preliminary scale parameter
s=LMSsca(r,0,p);

% Take into account a data point, if its residual is relatively small
w=find(abs(r/s)<=2.5);
Xrls=X(w,:);
yrls=y(w);
