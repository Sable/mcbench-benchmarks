function nbins = calcnbins(x, method, minimum, maximum)
% Calculate the "ideal" number of bins to use in a histogram, using a
% choice of methods.
% 
% NBINS = CALCNBINS(X, METHOD) calculates the "ideal" number of bins to use
% in a histogram, using a choice of methods.  The type of return value
% depends upon the method chosen.  Possible values for METHOD are:
% 'fd': A single integer is returned, and CALCNBINS uses the
% Freedman-Diaconis method,
% based upon the inter-quartile range and number of data.
% See Freedman, David; Diaconis, P. (1981). "On the histogram as a density
% estimator: L2 theory". Zeitschrift für Wahrscheinlichkeitstheorie und
% verwandte Gebiete 57 (4): 453-476.

% 'scott': A single integer is returned, and CALCNBINS uses Scott's method,
% based upon the sample standard deviation and number of data.
% See Scott, David W. (1979). "On optimal and data-based histograms".
% Biometrika 66 (3): 605-610.
% 
% 'sturges': A single integer is returned, and CALCNBINS uses Sturges'
% method, based upon the number of data.
% See Sturges, H. A. (1926). "The choice of a class interval". J. American
% Statistical Association: 65-66.
% 
% 'middle': A single integer is returned.  CALCNBINS uses all three
% methods, then picks the middle (median) value.
% 
% 'all': A structure is returned with fields 'fd', 'scott' and 'sturges',
% each containing the calculation from the respective method.
% 
% NBINS = CALCNBINS(X) works as NBINS = CALCNBINS(X, 'MIDDLE').
% 
% NBINS = CALCNBINS(X, [], MINIMUM), where MINIMUM is a numeric scalar,
% defines the smallest acceptable number of bins.
% 
% NBINS = CALCNBINS(X, [], MAXIMUM), where MAXIMUM is a numeric scalar,
% defines the largest acceptable number of bins.
% 
% Notes: 
% 1. If X is complex, any imaginary components will be ignored, with a
% warning.
% 
% 2. If X is an matrix or multidimensional array, it will be coerced to a
% vector, with a warning.
% 
% 3. Partial name matching is used on the method name, so 'st' matches
% sturges, etc.
% 
% 4. This function is inspired by code from the free software package R
% (http://www.r-project.org).  See 'Modern Applied Statistics with S' by
% Venables & Ripley (Springer, 2002, p112) for more information.
% 
% 5. The "ideal" number of depends on what you want to show, and none of
% the methods included are as good as the human eye.  It is recommended
% that you use this function as a starting point rather than a definitive
% guide.
% 
% 6. The wikipedia page on histograms currently gives a reasonable
% description of the algorithms used.
% See http://en.wikipedia.org/w/index.php?title=Histogram&oldid=232222820
% 
% Examples:     
% y = randn(10000,1);
% nb = calcnbins(y, 'all')
%    nb = 
%             fd: 66
%          scott: 51
%        sturges: 15
% calcnbins(y)
%    ans =
%        51
% subplot(3, 1, 1); hist(y, nb.fd);
% subplot(3, 1, 2); hist(y, nb.scott);
% subplot(3, 1, 3); hist(y, nb.sturges);
% y2 = rand(100,1);
% nb2 = calcnbins(y2, 'all')
%    nb2 = 
%             fd: 5
%          scott: 5
%        sturges: 8
% hist(y2, calcnbins(y2))
% 
% See also: HIST, HISTX
% 
% $ Author: Richard Cotton $		$ Date: 2008/10/24 $    $ Version 1.5 $

% Input checking
error(nargchk(1, 4, nargin));

if ~isnumeric(x) && ~islogical(x)
    error('calcnbins:invalidX', 'The X argument must be numeric or logical.')
end

if ~isreal(x)
   x = real(x);
   warning('calcnbins:complexX', 'Imaginary parts of X will be ignored.');
end

% Ignore dimensions of x.
if ~isvector(x)
   x = x(:);
   warning('calcnbins:nonvectorX', 'X will be coerced to a vector.');
end

nanx = isnan(x);
if any(nanx)
   x = x(~nanx);
   warning('calcnbins:nanX', 'Values of X equal to NaN will be ignored.');
end

if nargin < 2 || isempty(method)
   method = 'middle';
end

if ~ischar(method)
   error('calcnbins:invalidMethod', 'The method argument must be a char array.');
end

validmethods = {'fd'; 'scott'; 'sturges'; 'all'; 'middle'};
methodmatches = strmatch(lower(method), validmethods);
nmatches = length(methodmatches);
if nmatches~=1
   error('calnbins:unknownMethod', 'The method specified is unknown or ambiguous.');
end
method = validmethods{methodmatches};

if nargin < 3 || isempty(minimum)
   minimum = 1;
end

if nargin < 4 || isempty(maximum)
   maximum = Inf;
end
   
% Perform the calculation
switch(method)
   case 'fd'
      nbins = calcfd(x);
   case 'scott'
      nbins = calcscott(x);
    case 'sturges'
      nbins = calcsturges(x);
   case 'all'
      nbins.fd = calcfd(x);    
      nbins.scott = calcscott(x);
      nbins.sturges = calcsturges(x);
   case 'middle'
      nbins = median([calcfd(x) calcscott(x) calcsturges(x)]);
end

% Calculation details
   function nbins = calcfd(x)
      h = diff(prctile0(x, [25; 75])); %inter-quartile range
      if h == 0
         h = 2*median(abs(x-median(x))); %twice median absolute deviation
      end
      if h > 0
         nbins = ceil((max(x)-min(x))/(2*h*length(x)^(-1/3)));
      else
         nbins = 1;
      end
      nbins = confine2range(nbins, minimum, maximum);
   end

   function nbins = calcscott(x)
      h = 3.5*std(x)*length(x)^(-1/3);
      if h > 0 
         nbins = ceil((max(x)-min(x))/h);
      else 
         nbins = 1;
      end
      nbins = confine2range(nbins, minimum, maximum);
   end

   function nbins = calcsturges(x)
      nbins = ceil(log2(length(x)) + 1);
      nbins = confine2range(nbins, minimum, maximum);
   end

   function y = confine2range(x, lower, upper)
      y = ceil(max(x, lower));
      y = floor(min(y, upper));
   end

   function y = prctile0(x, prc)
      % Simple version of prctile that only operates on vectors, and skips
      % the input checking (In particluar, NaN values are now assumed to
      % have been removed.)
      lenx = length(x);
      if lenx == 0
         y = [];
         return
      end
      if lenx == 1
         y = x;
         return
      end
      
      function foo = makecolumnvector(foo)
         if size(foo, 2) > 1 
            foo = foo';
         end
      end
         
      sortx = makecolumnvector(sort(x));
      posn = prc.*lenx/100 + 0.5;
      posn = makecolumnvector(posn);
      posn = confine2range(posn, 1, lenx);
      y = interp1q((1:lenx)', sortx, posn);
   end
end