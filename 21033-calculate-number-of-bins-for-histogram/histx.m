function [n, xout] = histx(varargin)
% A wrapper for hist that picks the "ideal" number of bins to use if
% unspecified. 
% 
% N = HISTX(Y) bins the elements of Y into M equally spaced containers and
% returns the number of elements in each container.  If Y is a matrix, HIST
% works down the columns.  The value of M is the middle (median) value of
% the optimal number of bins calculated using the Freedman-Diaconis, Scott
% and Sturges methods.  See below for further information on these methods.
% 
% N = HISTX(Y,M), where M is a scalar, uses M bins.  (This is identical to
% N = HIST(Y,M).)
% 
% N = HISTX(Y, X), where X is a vector, returns the distribution of Y among
% bins with centers specified by X. The first bin includes data between
% -inf and the first center and the last bin includes data between the last
% bin and inf. Note: Use HISTC if it is more natural to specify bin edges
% instead.  (This is identical to N = HIST(Y,X).) 
% 
% N = HISTX(Y, METHOD), where METHOD is a string chooses the number of bins
% as follows:
% 
% 'fd': The Freedman-Diaconis method, based upon the inter-quartile range
% and number of data, is used. 
% 'scott': The Scott method, based upon the sample standard deviation and
% nnumber of data, is used. 
% 'sturges': The Sturges method, based upon the number of data, is used.
% 'middle': All three methods are tried, and the middle value is used.
% 
% N = HISTX(Y, [], MINIMUM), where MINIMUM is a numeric scalar, defines the
% smallest acceptable number of bins.
% 
% N = HISTX(Y, [], [], MAXIMUM), where MAXIMUM is a numeric scalar, defines the
% largest acceptable number of bins.
% 
% HISTX(...) without output arguments produces a histogram bar plot of the
% results. The bar edges on the first and last bins may extend to cover the
% min and max of the data unless a matrix of data is supplied.
% 
% HISTX(Y, 'all') produces three histograms in a new figure window, drawn
% with the number of bins calculated using each of the three methods.
% 
% HISTX(AX, ...) plots into AX instead of GCA.
% 
% Notes:  
% 1. When the method chosen is 'all', any axes inputted will be ignored
% with a warning.  Likewise for output arguments.
% 
% 2. References for the methods can be found in the help page for
% CALCNBINS.
% 
% Examples:
% y = randn(10000,1);
% histx(y)
% histx(y, 'all')
% 
% See also: CALCNBINS, HIST.
% 
% $ Author: Richard Cotton $		$ Date: 2008/08/28 $    $ Version 1.1 $

% Check there is at least one input, and see if the first input is an axis.
error(nargchk(1,inf,nargin,'struct'));
[cax,args,nargs] = axescheck(varargin{:});

plotall = false;
y = args{1};

% If the number of bins wasn't specified, calculate it using calcnbins.
if nargs < 4 || isempty(args{4})
   args{4} = []; % this also sets missing arguments before this positon to [].
end

if ~isempty(args{2}) && isnumeric(args{2})
   nbins = args{2};
else
   nbins = calcnbins(y, args{2}, args{3}, args{4});
   if ischar(args{2}) && strcmpi(args{2}, 'all')
      plotall = true;
   end
end

% Plot the histogram(s)
if plotall
   if nargout > 0 
      warning('histx:ignoreargout', 'No arguments will be returned when the method is "all".');
   end
   if ~isempty(cax)
      warning('histx:ignoreaxes', 'The input axes are ignored when the method is "all".');
   end
   n = [];
   xout = [];
   figure();
   subplot(3, 1, 1); hist(y, nbins.fd);
   title('Freedman-Diaconis'' method');
   subplot(3, 1, 2); hist(y, nbins.scott);
   title('Scott''s method');
   subplot(3, 1, 3); hist(y, nbins.sturges);
   title('Sturges'' method');
else
   if nargout==0
      if isempty(cax)
         hist(y, nbins);
      else
         hist(cax, y, nbins);
      end
   else
      if isempty(cax)
      [n, xout] = hist(y, nbins);
   else
      [n, xout] = hist(cax, y, nbins);
      end
   end
end