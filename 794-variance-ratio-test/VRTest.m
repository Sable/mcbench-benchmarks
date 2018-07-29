function [vrt,zvrt]=VRTest(x,q,cor)
%Syntax: [vrt,zvrt]=VRTest(x,q,cor)
%__________________________________
%
% Calculates the Variance Ratio Test (VRTest) of a time series x, with
% or without the heteroskedasticity correction.
%
% vrt is the the value of the VRTest.
% zvrt is the z-score of the VRTest.
% x is the time series.
% q is an index scalar/vector.
% cor can take one of the following values
%  'hom' is for homoskedastic time series
%  'het' is for heteroskedastic time series
%
% Reference:
% Lo A, MacKinley AC (1989): The size and power of the variance
% ratio test in finite samples. Journal of Econometrics 40:203-238.
%
% Alexandros Leontitsis
% Institute of Mathematics and Statistics
% University of Kent at Canterbury
% Canterbury
% Kent, CT2 7NF
% U.K.
% University e-mail: al10@ukc.ac.uk (until December 2001)
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421
%
% June 15, 2001.

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

if nargin<2 | isempty(q)==1
   q=2;
else
   % q must be a scalar or a vector
   if min(size(q))>1
      error('q must be a scalar or a vector.');
   end
   % q must contain integers
   if round(q)-q~=0
      error('q must contain integers');
   end
   % q values must be between 2 and n/2-1
   if length((find(q<2 & q>=n/2)))>0
      error('q values must be between 2 and n/2-1');
   end
end

% If cor is ommited assume homoskedastic time series
if nargin<3 | isempty(cor)==1
   cor='hom';
end


% Estiamte the mean
mu=(x(n)-x(1))/n;

% Estimate the variance for the 1st order difference
s1=sum((x(2:n)-x(1:n-1)-mu).^2)/(n-1);

for i=1:length(q)
   m=(n-q(i)+1)*(1-q(i)/n);
   % Estimate the variance for the q-th order difference
   sq=sum((x(1+q(i):n)-x(1:n-q(i))-q(i)*mu).^2)/m;
   % The raw value of the VRT
   vrt(i)=sq/(s1*q(i));
   % Calculate the variance of the VRT
   switch cor
   case 'hom' % For homoskedastic time series
      varvrt=2*(2*q(i)-1)*(q(i)-1)/(3*q(i)*n);
   case 'het' % For heteroskedastic time series
      varvrt=0;
      sum2=sum((x(2:n)-x(1:n-1)-mu).^2);
      for j=1:q(i)-1
         sum1a=(x(j+2:n)-x(j+1:n-1)-mu).^2;
         sum1b=(x(2:n-j)-x(1:n-j-1)-mu).^2;
         sum1=sum1a'*sum1b;
         delta=sum1/(sum2^2);
         varvrt=varvrt+((2*(q(i)-j)/q(i))^2)*delta;
      end
   otherwise
      % cor must take the values "hom" or "het"
      error('cor must take the values "hom" or "het"');
   end
   % The z-score of the VRT
   zvrt(i)=(vrt(i)-1)/sqrt(varvrt);
end
