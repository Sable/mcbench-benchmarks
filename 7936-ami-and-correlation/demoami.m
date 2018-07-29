function demoami
% DEMOAMI demos function ami for bivariate time series data
%
% USAGE:
%       demoami
%
% INPUT:
%       
% OUTPUT:
%      amis:   vector of average mutual information for time lags of 0:nLags
%     corrs:   vector of correlation (or autocorrelation for univariate) for 
%              time lags of 0:nLags
%
% EXAMPLES:  
%
% See also AMI, PROBXY, RHIST 

% Copyright 2004-2005 by Durga Lal Shrestha.
% eMail: durgals@hotmail.com
% $Date: 2005/06/27
% $Revision: 1.1.0 $ $Date: 2005/07/01 $

% ***********************************************************************
clear all
close all
clc
mydata = load('data.txt')';
lag = 25;
nBins = [15 15];
[iy ry] = ami(mydata,nBins,lag);
