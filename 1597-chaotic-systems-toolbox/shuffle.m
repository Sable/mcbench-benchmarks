function s=shuffle(x,c)
%Syntax: s=shuffle(x,c)
%______________________
%
% Makes c shuffled surrogates of a time series x.
%
% s is the shuffled time series.
% x is the original time series.
% c is the number of surrogates.
%
%
% References:
%
% Theiler J, Galdrikian B, Longtin A, Eubank S, Farmer D J (1992): Using 
% Surrogate Data to Detect Nonlinearity in Time Series. In Nonlinear Modeling
% and Forecasting, eds. Casdagli M & Eubank S. 163-188. Addison-Wesley
%
% Theiler J, Eubank S,Galdrikian B, Longtin A,  Farmer D J (1992): Testing
% for nonlinearity in time series: the method of surrogate data. Physica D
% 58: 77-94
%
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
% 12 Apr 2001.

if nargin<1 | isempty(x)==1
   error('You should provide a time series.');
else
   % x must be a vector
   if min(size(x))>1
      error('Invalid time series.');
   end
   x=x(:);
   % N is the time series length
   N=length(x);
end

if nargin<2 | isempty(c)==1
   c=1;
else
   % c must be scalar
   if sum(size(c))>2
      error('c must be scalar.');
   end
   % c must be greater or equal than 1
   if c<1
      error('c must be greater or equal than 1.');
   end
end

for i=1:c
    
    % Make a random vector with indices up to n
    s1=randperm(N);
    
    % Shuffle the original x with respect to s1
    s(:,i)=x(s1);
end

