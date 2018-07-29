function [x50,x,TX,CX]=MVE(X)
%Syntax: [x50,x,TX,CX]=MVE(X)
%____________________________
%
% Calculates the Minimum Vulume Ellipsoid (MVE) of a data set X.
%
% x50 is the 50% of the points that form the MVE.
% x is the core subsample for the MVE.
% TX is the center of the MVE.
% CX is the inflated covariance matrix of the MVE.
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

if nargin<1 | isempty(X)==1
   error('Not enough input arguments.');
else
   % X must be 2-dimensional
   if ndims(X)>2
      error('Invalid data set.');
   end
   
   % n is the length of the data set, p is its dimension
   [n p]=size(X);
end

if n<p
   error('You must give a larger data set.');
end

%All the possible combinations of p+1 p-dimensional points
C=combnk(1:n,p+1);

volmin=Inf;
for i=1:size(C,1)
   for j=1:p+1
      A(j,:)=X(C(i,j),:);
   end
   if rank(A)==p
      
      %Chapter 7, eq. 1.23
      Cj=cov(A);
      
      %Chapter 7, eq. 1.24
      for j=1:n
         fact(j)=(X(j,:)-mean(A))*inv(Cj)*(X(j,:)-mean(A))';
      end
      mj2=median(fact);
      
      mj=sqrt(mj2);
      
      % Chapter 7, eq. 1.25 - The objective function
      vol=sqrt(det(Cj))*mj^(p-1);
     
      if vol<volmin
         volmin=vol;
         
         % Chapter 7, eq. 1.26 - MVE
         TX=mean(A);
         CX=mj2*Cj/chi2inv(0.5,p);
         
         % The core of the MVE
         x=A;
         
         % The 50% of the points contained in the MVE
         k=0;
         x50=[];
         for j=1:n
            if fact(j)<=mj2
               k=k+1;
               x50(k,:)=X(j,:);
            end
         end
      end
   end
end
