function [dlogCr,dlogr,dlogCrCI]=vr(logCr,logr,alpha)
%Syntax: [dlogCr,dlogr,dlogCrCI]=vr(logCr,logr,alpha)
%____________________________________________________
%
% Calculates the derivative of the Correlation Integral (Cr) with
% respect to the log(range) and its confidence interval (CI).
%
% dlogCr is the derivative of logCr.
% dlogr is the log(range).
% dlogCrCI is the confidence interval for dlogCr.
% alpha determines the 1-alpha CI for dlogCr.
% logCr is the the value of log(CI).
% logr is log(range).
%
% Alexandros Leontitsis
% Department of Education
% University of Ioannina
% 45110 - Dourouti
% Ioannina
% Greece
%
% University e-mail: me00743@cc.uoi.gr
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421
%
% June 15, 2001.

% logCr and logr must have the same number of rows
if size(logCr,1)~=size(logr,1)
   error('logCr and logr must have the same number of rows.');
end

if nargin<3
   alpha=0.05;
else
   % alpha must be a scalar
   if sum(size(alpha))>2
      error('alpha must be a scalar.');
   end
end

for i=1:size(logCr,2)
   for j=2:size(logCr,1)-1
      X=[ones(3,1) logr((j-1):(j+1))];
      [b,bci]=regress(logCr((j-1):(j+1),i),X,alpha);
      dlogCr(j-1,i)=b(2);
      dlogr(j-1,1)=logr(j);
      dlogCrCI(:,j-1,i)=bci(2,:);
   end
end

