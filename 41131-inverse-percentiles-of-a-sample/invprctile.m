function p = invprctile(x,xq,dim)
%INVPRCTILE  Inverse Percentiles of a sample.
% Calculates the nonexceedance probability for xq values from 
% sample of data x.
%
% USAGE:
%         p = INVPRCTILE(x,xq)
%         p = INVPRCTILE(x,xq,dim)
%        
% INPUT:
%    x - Vector or Matrix of sample data                                   
%    q - Values for non-exceedance probabilities to be computed. 
%        q can be scalar or vector 
% dim -  Dimension for matrix to be worked for non-exceedance probability
%       
% OUTPUT:
%    p - Non-exceedance probabilities values for q. When x is a vector, p is 
%        the same size as xq, and p(i) contains the non-exceedance probability
%        for xq(i) value.  When x is a matrix, the i-th row of p contains
%        the non-exceedance probability for xq(i)-values of each column of x.
%        For N-D arrays, INVPRCTILE operates along the first non-singleton
%        dimension.                                                                        
%        
% EXAMPLES:
%    x = rand(100,1);
%    q = [0.1 0.25 0.8];
%    p = invprctile(x,q);
%    % Check with prctile to get back the same results
%    qvalues = prctile(x,p)
%      
% See also: PRCTILE, WPRCTILE(FLEX)
%
% HISTORY:
% version 1.0.0, Release 2013/04/04: Initial release
% version 1.0.1, Release 2013/04/05: Bug fixing for not strictly monotonic
%                                    increasing x values

% Author: Durga Lal Shrestha
% CSIRO Land & Water, Highett, Australia
% eMail: durgalal.shrestha@gmail.com
% Website: www.durgalal.co.cc
% Copyright 2013 Durga Lal Shrestha
% $First created: 04-Apr-2013
% $Revision: 1.0.1 $ $Date: 05-Apr-2013 10:21:00 $

% ***********************************************************************
%% INPUT ARGUMENTS CHECK
narginchk(2, 3)

if ~isvector(xq) || numel(xq) == 0 || ~isreal(xq)
    error('invprctile:BadInvPercentile','Bad percentile values');
end

% Figure out which dimension prctile will work along.
sz = size(x);
if nargin < 3
    dim = find(sz ~= 1,1);
    if isempty(dim)
        dim = 1;
    end
    dimArgGiven = false;
else
    % Permute the array so that the requested dimension is the first dim.
    nDimsX = ndims(x);
    perm = [dim:max(nDimsX,dim) 1:dim-1];
    x = permute(x,perm);
    % Pad with ones if dim > ndims.
    if dim > nDimsX
        sz = [sz ones(1,dim-nDimsX)];
    end
    sz = sz(perm);
    dim = 1;
    dimArgGiven = true;
end

% If X is empty, return all NaNs.
if isempty(x)
    if isequal(x,[]) && ~dimArgGiven
        p = nan(size(xq),class(x));
    else
        szout = sz; szout(dim) = numel(xq);
        p = nan(szout,class(x));
    end
    
else
    % Drop X's leading singleton dims, and combine its trailing dims.  This
    % leaves a matrix, and we can work along columns.
    nrows = sz(dim);
    ncols = prod(sz) ./ nrows;
    x = reshape(x, nrows, ncols);
    
    x = sort(x,1);
    nonnans = ~isnan(x);
    
    % For interpolation yi = interp1(x,Y,xi) x must be vector,so work on
    % each column separately.
    extrapvalMin = 0; % extrapolation value for outsite range (lower end)
    extrapvalMax = 1; % extrapolation value for outsite range (upper end)
    
    % Get percentiles of the non-NaN values in each column.
    p = nan(numel(xq), ncols, class(x));
    for j = 1:ncols
        nj = find(nonnans(:,j),1,'last');
        if nj > 0
            pp =((1:nj)-0.5)./nj;  % Plotting position pp(k) = (k-0.5)/n
            xx = x(1:nj,j);
            % Bug fixing for not strictly monotonic increasing x values
            % (2013/04/05, version 1.0.1)
            [xx, ind] = unique(xx);
            pp = pp(ind);   
            if length(xx)==1     % if only single xx
                p(:,j)=100;
                ind = xq < xx;   % for xq < xx cdf is zero, for xq >=xx cdf is 100
                p(ind,j)=0;
            else
                p(:,j) = interp1(xx,pp,xq(:),'linear',extrapvalMin).*100;
                % Perform extrapolation for elements of xq outside the range of xx
                % extptids = xq < xx(1);
                % p(extptids,j) = extrapvalMin; % already done with interp1
                extptids =  xq > xx(end);
                p(extptids,j) = extrapvalMax.*100;
            end
        end
    end
    
    % Reshape p to conform to X's original shape and size.
    szout = sz; szout(dim) = numel(xq);
    p = reshape(p,szout);
end
% undo the DIM permutation
if dimArgGiven
    p = ipermute(p,perm);
end

% If X is a vector, the shape of p should follow that of xq, unless an
% explicit DIM arg was given.
if ~dimArgGiven && isvector(x)
    p = reshape(p,size(xq));
end
