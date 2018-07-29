function [n,xc,index] = ahist(varargin)
% AHIST  Alternative to Histogram.
% Motivation: to combine the good features of HIST and HISTC.
%
% USAGE:
%            n = ahist(Y)
%            n = ahist(Y,nbin)
%            n = ahist(Y,xedges)
% [n,xc,index] = ahist(...)
%                ahist(...) without output arguments produces a 
%                histogram bar plot of the results.
% 
% INPUT:    
%       Y:    Vector or Matrix of data. If Y is Matrix, AHIST works down 
%             the columns.
%    nbin:    Number of bins 
%  xedges:    Matrix of edges for each column vector of data
%           
% OUTPUT: 
%        n:    Number of elements in each container. 				
%       xc:    The position of the bin centers in X
%    index:    Index matrix BIN.
%
% FEATURES:
% 1. Returns the index matrix (histc)
% 2. Either uses nbins (hist) or xedges (histc)
% 3. Returns centre of the bin (hist)
% 4. Plot histogram of each column of matrix in subplots
%
% WHY AHIST:
% 1. Note that in histc, the last bin counts any values of x that
%    match edges(end). But AHIST(Y) bins the elements of Y into 10 equally 
%    spaced containers like in hist.
% 2. When working the matrix, HIST and HISTC uses same container based on
%    the range of the whole matrix for all column of the matrix. 
%    But AHIST uses different container for each column based on the range 
%    of data in each column.
%
% See also  HIST HISTC         
%
% Copyright 2004-2007 by Durga Lal Shrestha.
% eMail: durgals@hotmail.com
% $Date: 2007/10/02 
% $Revision: 1.0.0 $ $Date: 2007/10/02 $

% ********************************************************************

error(nargchk(1,2,nargin));

y = varargin{1};
if nargin == 1
    x = 10;
else
    x = varargin{2};
end

if min(size(y))==1, y = y(:); end
if ~isnumeric(x) || ~isnumeric(y)
    error('MATLAB:ahist:InvalidInput', 'Input arguments must be numeric.')
end
nc = size(y,2);

if isempty(y)
    % No elements to count
    return
end
 
[nredge ncedge] = size(x);
if ~isscalar(x) && ~isvector(y)
	if min(size(x))>1
		if ncedge ~= nc
			error('MATLAB:ahist:InvalidInput', ...
				'The number of columns of edges matrix should be equal to those of y matrix');
		end
	end
end
  
% Start columnwise calculation
for i=1:nc
	%  Ignore NaN when computing miny and maxy.
	nanind = ~isnan(y(:,i));
	miny = min(y(nanind,i));
	maxy = max(y(nanind,i));
	%  miny, maxy are empty only if all entries in y are NaNs.  In this case,
	%  max and min would return NaN, thus we set miny and maxy accordingly.
	if (isempty(miny))
		miny = NaN;
		maxy = NaN;
	end

	if length(x) == 1
		% All the columns will have same number of bins
		if miny == maxy,
			miny = miny - floor(x/2) - 0.5;
			maxy = maxy + ceil(x/2) - 0.5;
		end
		binwidth = (maxy - miny) ./ x;
		xx = miny + binwidth*(0:x);
		xx(length(xx)) = maxy;
		xcc(:,i) = xx(1:length(xx)-1) + binwidth/2;

	else
		if nredge == 1 || ncedge == 1      % vector
			xx = x;
			if ncedge == 1       % convert to row vector
				xx=xx';
			end
		else
			xx = x(:,i);    % matrix of edges
			xx=xx';
		end
		xx(1) = min(xx(1),miny);
		xx(end) = max(xx(end),maxy);

		xx1 = xx(1:end-1);
		xx2 = xx(2:end);
		xcc(:,i) = (xx1+xx2)/2;
	end
	% Shift bins so the interval is ( ] instead of [ ).

	bins = xx + eps(xx);
	[nn ind]= histc(y(:,i),[-inf bins],1);

	% Combine first bin with 2nd bin and last bin with next to last bin
	nn(2) = nn(2)+nn(1);
	firstind = find(ind==1);
	ind(firstind)=2;
	nn(end-1) = nn(end-1)+nn(end);
	lastind = find(ind==length(nn));
	ind(lastind)=length(nn)-1;
	nnn(:,i) = nn(2:end-1);
	indexx(:,i) = ind-1;
end

if nargout == 0
	rows  = ceil(sqrt(nc));
	cols  = ceil(nc/rows);
	for i = 1:nc
		subplot(rows,cols,i);
		bar(xcc(:,i),nnn(:,i),'hist');
		xlim([min(y(:,i)) max(y(:,i))])
		xlabel(['Column ' num2str(i)])
	end
else
	n = nnn;
	xc = xcc;
	index = indexx;
end
