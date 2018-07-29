function y = jitter(x, factor, uniformOrGaussianFlag, smallOrRangeFlag, realOrImaginaryFlag)
% Adds a small amount of noise to an input vector, matrix or N-D array. The
% noise can be uniformly or normally distributed, and can have a magnitude
% based upon the range of values of X, or based upon the smallest
% difference between values of X (excluding 'fuzz').
% 
% NOTE: This function accepts complex values for the first input, X.  If
% any values of X have imaginary components (even zero-valued imaginary
% components), then by default the noise will be imaginary.  Otherwise, the
% default is for real noise.  You can choose between real and imaginary
% noise by setting the fifth input parameter (see below).
% 
% Y = JITTER(X) adds an amount of uniform noise to the input X, with a
% magnitude of one fifth of the smallest difference between X values
% (excluding 'fuzz'), i.e. the noise, n~U(-d/5, d/5), where d is the
% smallest difference between X values.
% 
% Y = JITTER(X, FACTOR) adds noise as above, but scaled by a factor
% of FACTOR, i.e. n~U(-FACTOR*d/5, FACTOR*d/5).
% 
% Y = JITTER(X, FACTOR, 1) adds noise as above, but normally distributed
% (white noise), i.e. n~N(0, FACTOR*d/5). JITTER(X, FACTOR, 0) works the
% same as JITTER(X, FACTOR). If the second parameter is left empty (for
% example JITTER(X, [], 1)), then a default scale factor of 1 is used.
% 
% Y = JITTER(X, FACTOR, [], 1) adds an amount of noise to X with a
% magnitude of one fiftieth of the range of X.  JITTER(X, FACTOR, [], 0)
% works the same as JITTER(X, FACTOR, []).  A value of 0 or 1 can be given as
% the third input to choose between uniform and normal noise (see above),
% i.e. n~U(-FACTOR*r/50, FACTOR*r/50) OR n~N(0, FACTOR*r/50), where r is
% the range of the values of X.  If the second parameter is left empty then
% a default scale factor of 1 is used.
% 
% Y = JITTER(X, FACTOR, [], [], 1) adds an amount of noise as above, but
% with imaginary noise.  The magnitude of the noise is the same as in the
% real case, but the phase angle is a uniform random variable, theta~U(0,
% 2*pi).  JITTER(X, FACTOR, [], [], 0) works the same as JITTER(X, FACTOR,
% [], []). A value of 0 or 1 can be given as the third input to choose
% between uniform and normal noise, and a value of 0 or 1 can be given as
% the fourth input to choose between using the smallest distance between
% values or the range for determining the magnitude of the noise.  If the
% second parameter is left empty then a default scale factor of 1 is used.
% 
% 
% EXAMPLE:  x = [1 -2 7; Inf 3.5 NaN; -Inf 0.001 3];
%           jitter(x)
% 
%           ans =
% 
%             0.9273   -2.0602    6.9569
%                Inf    3.4597       NaN
%               -Inf    0.0333    2.9130
% 
%           %Plot a noisy sine curve. 
%           x2 = sin(0:0.1:6);
%           plot(jitter(x2, [], 1, 1));  
% 
% 
% ACKNOWLEGEMENT: This function is based upon the R function of the same
% name, written by Werner Stahel and Martin Maechler, ETH Zurich.
% See http://stat.ethz.ch/R-manual/R-patched/library/base/html/jitter.html
% for details of the original.
% 
% 
%   Class support for input X:
%      float: double, single
% 
% 
%   See also RAND, RANDN.
% 
% 
% $ Author: Richie Cotton $     $ Date: 2006/03/21 $


% Check number of inputs
if nargin < 1
    error('jitter:notEnoughInputs', 'This function requires at least one input.');
end
    
% Set defaults where required
if nargin < 2 || isempty(factor)
    factor = 1;
end

if nargin < 3 || isempty(uniformOrGaussianFlag)
    uniformOrGaussianFlag = 0;
end

if nargin < 4 || isempty(smallOrRangeFlag)
    smallOrRangeFlag = 0;
end

if nargin < 5 || isempty(realOrImaginaryFlag)
    realOrImaginaryFlag = ~isreal(x);
end


% Find the range of X, ignoring infinite value and NaNs
xFinite = x(isfinite(x(:)));
xRange = max(xFinite) - min(xFinite);

if ~smallOrRangeFlag
    % Remove 'fuzz'
    dp = 3 - floor(log10(xRange));
    xFuzzRemoved = round(x * 10^dp) * 10^-dp;
    % Find smallest distance between values of X
    xUnique = unique(sort(xFuzzRemoved));
    xDifferences = diff(xUnique);
    if length(xDifferences)
        smallestDistance = min(xDifferences);
    elseif xUnique ~= 0 
        % In this case, all values are the same, so xUnique has length 1
        smallestDistance = 0.1 * xUnique;
    else
        % In this case, all values are 0
        smallestDistance = 0.1 * xRange;
    end
    scaleFactor = 0.2 * factor * smallestDistance;
else
    % Calc scale factor based upon range
    scaleFactor = 0.02 * factor * xRange;
end

% Add the noise
s = size(x);
if uniformOrGaussianFlag
    % Normal noise
    if realOrImaginaryFlag
        randomPhaseAngles = 2 * pi * rand(s);
        y = x + scaleFactor * randn(s) * exp(randomPhaseAngles * i);
    else
        y = x + scaleFactor * randn(s);
    end
else
    % Uniform noise
    if realOrImaginaryFlag
        randomPhaseAngles = 2 * pi * rand(s);
        y = x + scaleFactor * (2*rand(s)-1) * exp(randomPhaseAngles * i);
    else
        y = x + scaleFactor * (2*rand(s)-1);
    end
end