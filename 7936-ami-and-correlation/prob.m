function [py nBins]= prob(varargin)
% PROB calculates probability distribution of y among nBins number of bins
%
% USAGE:
%       [py nBins]= prob(y)
%       [py nBins]= prob(y,maxBins)
%
% INPUT:
%         y:   data
%	  maxBins:   number of bins to compute the distribution of y among maxBins
%      
% OUTPUT:
%        py:    probability distribution of y
%     nBins:    number of bins computed such that any of bins does not
%               have zero probability distribution
%
% EXAMPLES:
%
% See also PROB, PROBXY, RHIST 

% Copyright 2004-2005 by Durga Lal Shrestha.
% eMail: durgals@hotmail.com
% $Date: 2005/06/27
% $Revision: 1.1.0 $ $Date: 2005/07/01 $

% ***********************************************************************
%% INPUT ARGUMENTS CHECK
error(nargchk(1,2,nargin));
y = varargin{1};
if  nargin == 1    
    maxBins = 10;
else
    maxBins = varargin{2};
end
if ~isvector(y)
    error('Invalid data size: y should be vector')
else
    y = y(:);
end

%**************************************************************************
%% Computation

preBin = 0;
isNotZeroBin = false;
iter = 0;
cBin = maxBins;
while preBin ~= cBin
    zeroDistribution = isZeroDistribution(y,cBin);
    iter = iter+1;
    if ~zeroDistribution % not zero distribution; increase bin
        if iter == 1 % if first iteration then accept user provided number of bins
            break
        end
        tmpBin = cBin;
        nonZeroBin = cBin;
        cBin = floor((zeroBin+nonZeroBin)/2);
        preBin = tmpBin; 
        isNotZeroBin = true;
    else        % zero distribution; reduce bin
        if ~isNotZeroBin    % if previous number of bins contains zero 
            preBin = cBin;    % distribution, then decreases by factor of 2 
            zeroBin = cBin;
            cBin = floor(cBin/2);
        else
            tmpBin = cBin;     % if previous number of bins does not contain zero
            zeroBin = cBin;    % distribution, then decreases by taking average 
            cBin = floor((zeroBin+nonZeroBin)/2);
            preBin = tmpBin;
        end        
    end       
end
nBins = cBin;
py = rhist(y,nBins);
%
%**************************************************************************
%% INTERNAL FUNCTION TO CHECK WHETHER A GIVEN NUMBER OF BINS CONTAINS ZERO
% DISTRIBUTION OF DATA IN ATLEAST ONE OF THE BINS.
function trueOrFalse = isZeroDistribution(y,nBins)
% ISZERODISTRIBUTION returns "True" if atleast one of the bins contains zero
%                    distribution of data, otherwise "False"
%
% USAGE:
%       zeroOrOne = isZeroDistribution(y,nBins)
%
% INPUT:
%            y:   data
%	       nBins:   number of bins to compute the distribution of y among nBins
%	  
% OUTPUT:
%   trueOrFalse:  "True" if atleast one of the bins contains zero Distribution
%                 of data, otherwise "False"
%
% See also PROB, PROBXY, RHIST 

% Copyright 2004-2005 by Durga Lal Shrestha.
% eMail: durgals@hotmail.com
% $Date: 2005/06/27
% $Revision: 1.1.0 $ $Date: 2005/07/01 $
%
% ***********************************************************************
%% INPUT ARGUMENTS CHECK
error(nargchk(2,2,nargin));

if ~isvector(y)
    error('Invalid data size: y should be vector')
else
    y = y(:);
end
%
%**************************************************************************
%% COMPUTATION
[nn x]=rhist(y,nBins);
clear x;
z = find(nn == 0);
if length(z)>0
    trueOrFalse = true;  % zero distribution of data
else
    trueOrFalse = false;
end
