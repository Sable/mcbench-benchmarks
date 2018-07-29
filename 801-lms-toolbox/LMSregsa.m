function [z,LMSout,blms,Rsq]=LMSregsa(y,X)
%Syntax: [LMSout,blms,Rsq]=LMSregsa(y,X)
%_____________________________________
%
% Calculates the Least Median of Squares (LMS) simple/multiple
% regression parameters and output. It searches all the possible
% combinations of points and makes the intercept adjustment for
% every combination.
%
% LMSout is the LMS estimated values vector.
% blms is the LMS [intercept slopes] vector.
% Rsq is the R-squared.
% y is the column vector of the dependent variable.
% X is the matrix of the independent variable.
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
else
   % y must be a column vector
   y=y(:);
   % n is the length of the data set
   n=length(y);
end
   
if nargin<2 | isempty(X)==1
   % if X is omitted give it the values 1:n
   X=(1:n)';
else
   % X must be a 2-dimensional matrix
   if ndims(X)>2
      error('Invalid data set X.');
   end
   if n~=size(X,1)
      error('The rows of X and y must have the same length');
   end
end

% p is the number of parameters to be estimated
p=size(X,2)+1;

% The "half" of the data points
h=floor(n/2)+floor((p+1)/2);

% bint is the interval of b
% Nasdaq
%bint=[0.000132 0.000136];
% GIASE
%bint=[0.000212 0.000216];

bint=[0 0.0004];
brange=bint(2)-bint(1);

% initial guess
cinit=[1 mean(bint)];

rmin=Inf;

for j=1:10
    
    if j>1
        bint=[blms(2)-brange*0.9 blms(2)+brange*0.9];
    end
    
    
    for i=1:10000
        
        c=[1;bint(1)+i/10000*brange];
        
        % Make the intercept adjustment
        est1=[ones(n,1) X]*c;
        c1=LMSloc(y-est1);
        c(1)=c(1)+c1;
        
        % Calculate the median squared error
        est=[ones(n,1) X]*c;
        r=y-est;
        r2=r.^2;
        r2=sort(r2);
        rlms=r2(h);
        
        z(i,:)=[bint(1)+i/10000*brange rlms];
        
        if rlms<rmin
            rmin=rlms;
            blms=c;
            LMSout=est;
            % Chapter 2, eq. 3.11
            Rsq=1-(median(abs(r))/median(abs(y-median(y))))^2;
        end
    end
    
    
end
