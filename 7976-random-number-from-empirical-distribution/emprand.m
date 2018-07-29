function xr = emprand(dist,varargin)
%EMPRAND Generates random numbers from empirical distribution of data.                   
% This is useful when you do not know the distribution type (i.e. normal or
% uniform), but you have the data and you want to generate random 
% numbers form the data. The idea is to first construct cumulative distribution
% function (cdf) from the given data. Then generate uniform random number and
% interpolate from cdf. 
%
% USAGE:
%         xr = EMPRAND(dist)        - one random number  
%         xr = EMPRAND(dist,m)      - m-by-m random numbers
%         xr = EMPRAND(dist,m,n)    - m-by-n random numbers
%                                             
% INPUT:
%    dist - vector of distribution i.e. data values                                   
%       m - generates m-by-m matrix of random numbers  
%       n - generates m-by-n matrix of random numbers
%       
% OUTPUT:
%    xr - generated random numbers                                                                       
%        
% EXAMPLES:
% % Generate 1000 normal random numbers
% mu = 0; sigma = 1; nr = 1000;
% givenDist = mu + sigma * randn(nr,1);
% generatedDist = emprand(givenDist,nr,1);
% %
% % % Plot histogram to check given and generated distribution
% [n,xout] = hist(givenDist);
% hist(givenDist);
% hold on
% hist(generatedDist,xout)
% %
% Plot cdf to check given and generated distribution
% figure
% x = sort(givenDist(:));      % Given distribution
% p = 1:length(x);
% p = p./length(x);
% plot(x,p,'color','r');      
% hold on
%
% xr = sort(generatedDist(:)); % Generated distribution
% pr = 1:length(xr);
% pr = pr./length(xr);
% 
% plot(xr,pr,'color','b');
% xlabel('x')
% ylabel('cdf')
% legend('Given Dist.','Generated Dist.')
% title('1000 random numbers generated from given normal distribution of data');
% 
% HISTORY:
% version 1.0.0, Release 05-Jul-2005: Initial release
% version 1.1.0, Release 16-Oct-2007: Some bug fixes and improvement of help text
%    1. Can handle NaN values in dist
%    2. Extraplolate for out of range
%    3. Calling function EMPCDF is included within this function
%
% See also: 

% Author: Durga Lal Shrestha
% UNESCO-IHE Institute for Water Education, Delft, The Netherlands
% eMail: durgals@hotmail.com
% Website: http://www.hi.ihe.nl/durgalal/index.htm
% Copyright 2004-2007 Durga Lal Shrestha.
% $First created: 05-Jul-2005
% $Revision: 1.1.0 $ $Date: 16-Oct-2007 21:47:47 $

% ***********************************************************************
%% INPUT ARGUMENTS CHECK

error(nargchk(1,3,nargin));
if ~isvector(dist)
    error('Invalid data size: input data must be vector')
end
if nargin == 2 
    m = varargin{1};
    n = m;
elseif nargin == 3
    m = varargin{1};
    n = varargin{2};
else
    m = 1;
    n = 1;
end

%% COMPUTATION
x = dist(:);
% Remove missing observations indicated by NaN's.
t = ~isnan(x);
x = x(t);

% Compute empirical cumulative distribution function (cdf)
xlen = length(x);
x = sort(x);
p = 1:xlen;
p = p./xlen;   

% Generate uniform random number between 0 and 1
ur =  rand(m,n);

% Interpolate ur from empirical cdf and extraplolate for out of range
% values.
xr = interp1(p,x,ur,[],'extrap');
