function v=mai(x,lag)
%Syntax: v=mai(x,lag)
%____________________
%
% Calculates the mutual average information of a time series x for
% some time lag.
%
% v is the the value of the mutual average information.
% x is the time series.
% lag is the time lag.
%
% Alexandros Leontitsis
% Institute of Mathematics and Statistics
% University of Kent at Canterbury
% Canterbury
% Kent, CT2 7NF
% U.K.
% University e-mail: al10@ukc.ac.uk
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421
%
% May 25, 2001.

if nargin<1 | isempty(x)==1
   error('You should provide a time series.');
else
   % x must be a vector
   if min(size(x))>1
      error('Invalid time series.');
   end
   x=x(:);
   % n is the time series length
   n=length(x);
end

if nargin<2 | isempty(lag)==1
   lag=0:min(n/2-1,20);
else
   % lag must be a vector
   if min(size(lag))>1
      error('The time lag must be a scalar or a vector.');
   end
   % lag must contain integers
   lag=round(lag);
   % lag values must be between 0 and n/2-1
   lag=lag(find(lag>=0 & lag<n/2));
   % lag must not be empty
   if isempty(lag)==1
      error('You must give another set of values for lag.')
   end
end

% The mutual average information
x=x-min(x);
x=x/max(x);
for i=1:length(lag)
   
   % Define the number of bins
   k=floor(1+log2(n-lag(i))+0.5);
   
   % If the time series has no variance then the MAI is 0
   if var(x,1)==0
      v(i)=0;
   else
      v(i)=0;
      for k1=1:k
         for k2=1:k
            ppp=find((k1-1)/k<x(1:n-lag(i)) & x(1:n-lag(i))<=k1/k ...
               & (k2-1)/k<x(1+lag(i):n) & x(1+lag(i):n)<=k2/k);
            ppp=length(ppp);
            px1=find((k1-1)/k<x(1:n-lag(i)) & x(1:n-lag(i))<=k1/k);
            px2=find((k2-1)/k<x(1+lag(i):n) & x(1+lag(i):n)<=k2/k);
            if ppp>0
               ppp=ppp/(n-lag(i));
               px1=length(px1)/(n-lag(i));
               px2=length(px2)/(n-lag(i));
               v(i)=v(i)+ppp*log2(ppp/px1/px2);
            end
         end
      end
   end
end
