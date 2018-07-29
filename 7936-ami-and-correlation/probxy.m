function pxy = probxy(varargin)
% PROBXY calculates joint probability distribution of x and y among nBinsX
%        (for X data)and nBinsY (for Y data) 
%
% USAGE:
%        pxy = probxy(XY)
%        pxy = probxy(XY, nBinsX, nBinsY)
%
% INPUT:
%       XY:    2 dimesnional vector of data i.e. [X Y] where X and Y are
%              vectors of length n
%      
%	  nBinsX:    either number of bins (scalar) or vector of edges with 
%              monotonically non-decreasing values to compute the 
%              distribution of X among nBinsX or length (nBinX) bins
%   nBinsY:    either number of bins (scalar) or vector of edges with 
%              monotonically non-decreasing values to compute the
%              distribution of Y among nBinsY or length (nBinY) bins
%      
% OUTPUT:
%      pxy:    joint probability distribution of X and Y
%
% EXAMPLES:
%       
% See also AMI, PROB, RHIST

% Copyright 2004-2005 by Durga Lal Shrestha.
% eMail: durgals@hotmail.com
% $Date: 2005/06/27
% $Revision: 1.1.0 $ $Date: 2005/07/01 $

% ***********************************************************************
%% INPUT ARGUMENTS CHECK
error(nargchk(1,3,nargin));
XY = varargin{1};
[m, n] = size(XY);
if n > m
  XY = XY';    % Column vectors
  [m, n] = size(XY);
end
clear m;
if n ~= 2
  error('Invalid data size: XY should be two column vectors')
else
  X = XY(:,1);
  Y = XY(:,2);
end
if  nargin == 1
    nBinsX = 10;
    nBinsY = 10;
elseif  nargin == 2
    nBinsX = varargin{2};
    nBinsY = 10;
else
    nBinsX = varargin{2};
    nBinsY = varargin{3};
end
if isscalar(nBinsX) &  nBinsX > 0    % number of bins
    edgeX = computeEdge(X,nBinsX);
elseif size(nBinsX,1) == 1 | size(nBinsX,2) == 1
    edgeX = nBinsX(:);         % vector of edges
    nBinsX = length(edgeX)-1;
end
if isscalar(nBinsY) &  nBinsY > 0    % number of bins
    edgeY = computeEdge(Y,nBinsY);    
elseif size(nBinsY,1) == 1 | size(nBinsY,2) == 1
    edgeY = nBinsY(:);         % vector of edges
    nBinsY = length(edgeY)-1;
end

%**************************************************************************
%% COMPUTATION OF JOINT PROBABILITY DISTRIBUTION
nn = zeros(nBinsX,nBinsY);

for i = 1:nBinsX     
    [indX] = find(X >= edgeX(i) & X < edgeX(i+1));
    yFound = Y(indX);   
    if (~isempty(yFound))
        n = histc (yFound, edgeY);
        % combine last and second last bin since last bin contains value
        % matching edgeY(end)
        n(length(n)-1) = n(length(n)-1)+ n(length(n));
        n = n(1:length(n)-1);
        nn(i,:) = n';
    end    
end

pxy = nn./length(X);
%
%**************************************************************************
%% INTERNAL FUNCTION TO COMPUTE EDGE OF BINS
function [varargout]= computeEdge(varargin)
% COMPUTEEDGE computes edges and centre of bins
%
% USAGE:
%       [edge] = computeEdge(X)
%       [edge] = computeEdge(X,nBins)
%  [edge cntr] = computeEdge(...)
%
% INPUT:
%       X:     x data
%	  nBins:     number of bins to compute the distribution of y among nBins
%	  
% OUTPUT:
%     edge:    vector of bin edges
%     cntr:    vector of bin centres
%
% EXAMPLES:
%
% See also 

% Copyright 2004-2005 by Durga Lal Shrestha.
% eMail: durgals@hotmail.com
% $Date: 2005/06/27
% $Revision: 1.0.0 $ $Date: 2005/06/27 $

% ***********************************************************************
%% INPUT ARGUMENTS CHECK
error(nargchk(1,2,nargin));
X = varargin{1};

if  nargin == 1
    nBins = 10;
else
    nBins = varargin{2};
end
if ~isvector(X)
    error('Invalid data size: X should be vector')
else
    X = X(:);
end

%**************************************************************************
%% COMPUTATION
minX = min(X);
maxX = max(X);        	  
binwidth = (maxX - minX) ./ nBins;
edge = minX + binwidth*(0:nBins);
if nargout == 2
    varargout{2} = edge(1:length(edge)-1) + binwidth/2;      
end
varargout{1} = [-Inf edge(2:end-1) Inf];
