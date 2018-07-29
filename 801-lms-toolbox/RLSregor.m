function [Xrls,yrls]=RLSregor(y,X)
%Syntax: [xrls,yrls]=RLSregor(y,X)
%_________________________________
%
% Calculates the Reweighted Least Squares (RLS) regression data points
% from the LMS regression (through the origin).
%
% Xrls is the X values matrix to be taken into account for RLS.
% yrls is the y values vector to be taken into account for RLS.
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
   LMSout=LMSregor(y);
   X=(1:length(y))';
else
   LMSout=LMSregor(y,X);
end

% p is the number of parameters to be estimated
p=size(X,2);

% Calculate the residuals
r=y-LMSout;

% Estimate the preliminary scale parameter
s=LMSsca(r,0,p);

% Take into account a data point, if its residual is relatively small
w=find(abs(r/s)<=2.5);
Xrls=X(w,:);
yrls=y(w);
