function [amis corrs] = ami(xy,nBins,nLags)
% AMI computes and plots average mutual information (ami) and correlation for
%     lagged vector of univariate or bivariate time series.
%
% USAGE:
%       [amis corrs] = ami(xy,nBins,nLags)
%
% INPUT:
%       xy:    either univariate (x) or bivariate ([x y]) time series data               
%              If bivariate time series are given then x should be independent
%              variable and y should be dependent variable. Ami and correlation of 
%              x is calculated for lag time series of y. 
%              If univariate time series is given then autocorrelation is calculated 
%              instead of cross correlation.%              
%       nBins: number of bins for time series data to compute distribution which is 
%              required to compute ami. nBins should be either vector of 2 elements 
%              (for bivariate) or scalar (univariate).
%		    nLags: number of lags to compute ami and correlation.Computation is done for 
%              lags values of 0:nLags.
%      
% OUTPUT:
%       amis:  vector of average mutual information for time lags of 0:nLags
%       corrs: vector of correlation (or autocorrelation for univariate) for 
%              time lags of 0:nLags
%
% EXAMPLES:
%      % Create bivariate time series data xy
%      xy = rand(1000,2);
%      nBins = [15 10];
%      nLags = 25;
%      [amis corrs]= ami(xy,nBins,nLags);    
%
% See also AMI, PROBXY, RHIST 

% Copyright 2004-2005 by Durga Lal Shrestha.
% eMail: durgals@hotmail.com
% $Date: 2005/06/27
% $Revision: 1.1.0 $ $Date: 2005/07/01 $

% ***********************************************************************
%% INPUT ARGUMENTS CHECK
if nargin < 3,
	error('Not enough input arguments!');
end
if nargin > 3,
	error('Too many input arguments!');
end
[m, n] = size(xy);
if n > m
  xy = xy';    % Column vectors
  [m, n] = size(xy);
end
if n > 2 
  error('Invalid time series data: Time series should be univariate or bivariate')
elseif n == 2
  x = xy(:,1);
  y = xy(:,2);
elseif m == 1 | n == 1
  y = xy(:);
  x = xy;
end
nBins = nBins(:);
if size(nBins,1)> 2 | size(nBins,2)> 1|isempty(nBins)
   error('Invalid bin size: It should be either vector of 2 elements or scalar')
elseif size(nBins,1)== 2 & n == 2
  xBin = floor(nBins(1));
  yBin = floor(nBins(2));
elseif (size(nBins,1) == 1 & n == 2 )| n == 1 
  xBin =  floor(nBins(1));
  yBin = xBin;
else
   error('Invalid bin size: It should be either vector of 2 elements or scalar')
end
if ~isscalar(nLags)| nLags < 0
  error('Invalid lag: It should be a positive scalar')
end
if nLags > m
  error('Invalid lag: It should not be greater than length of time series data')
end

%**************************************************************************
%% AVERAGE MUTUAL INFORMATION AND CORRELATION COMPUTATION
nLags = floor(nLags);
amis = zeros(nLags+1,1);
corrs = zeros(nLags+1,1);
for i = 1:nLags+1 
    xlag = x(1:length(x)-i+1);
    ylag = y(i:length(x));
    [px xBinComputed] = prob(xlag,xBin);
    [py yBinComputed] = prob(ylag,yBin);
    pxy = probxy([xlag ylag], xBinComputed, yBinComputed);
    amixy = 0;
    for j = 1 :xBinComputed
        for k = 1 :yBinComputed
            if pxy(j,k)~= 0
                amixy= amixy + pxy(j,k).*log2(pxy(j,k)./px(j)./py(k));
            end
        end
    end
    amis(i) = amixy;       % Average mutual information
    correlation =  corrcoef([xlag ylag]);  
    corrs(i) = correlation(1,2);  % Correlation
end

%**************************************************************************
%% PLOT
if nLags > 1 
  t = 0:nLags;
  [AX,H1,H2] = plotyy(t,corrs,t,amis,'plot');
  set(get(AX(1),'Ylabel'),'String','Correlation')
  set(H1,'LineWidth',2)
  yLimit = ylim;
  ylim([yLimit(1) 1]);
  set(get(AX(2),'Ylabel'),'String','AMI')
  legend(H1,'Correlation','Location','NorthWest')
  legend(H2,'AMI' )
  xlabel('Time Lag')
  title('Correlation and Average Mutual Information')
end       
