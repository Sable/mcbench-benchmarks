function [X1,T1X,C1X]=RMVE(X)
%Syntax: [X1,T1X,C1X]=RMVE(X)
%____________________________
%
% Calculates the Reweighted Minimum Vulume Ellipsoid (RMVE) of a data
% set X.
%
% X1 is the data contained in the RMVE.
% T1X is the center of the RMVE.
% C1X is the covariance matrix of the RMVE.
% X is the matrix of the data set.
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

[x50,x,TX,CX]=MVE(X);

% n is the length of the data set, p is its dimension
[n p]=size(X);

% Chapter 7, eq. 1.28
j=0;
for i=1:n
   if (X(i,:)-TX)*inv(CX)*(X(i,:)-TX)'<=chi2inv(0.975,p)
      j=j+1;
      X1(j,:)=X(i,:);
   end
end

% Chapter 7, eq. 1.29
T1X=mean(X1);

% Chapter 7, eq. 1.30
C1X=cov(X1);

