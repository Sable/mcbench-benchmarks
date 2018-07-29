function gsd = geostd(x, flag, dim)
% For vectors, GEOSTD(X) calculates the geometric standard deviation of
% input X.  For  matrices GEOSTD calculates the geometric standard
% deviation over each column of X.  For N-D arrays, GEOSTD calculates the
% geometric standard deviation over the first non-singleton dimension of X.
% 
% 
% WARNING: By default GEOSTD normalises by N, where N is the sample size.
% This is different to the way the built-in MATLAB function STD operates.
% 
% 
% GEOSTD(X, 0) calculates the geometric standard deviation as above, with
% normalisation factor (N-1).  GEOSTD(X, 1) works like GEOSTD(X).
% 
% 
% GEOSTD(X, [], DIM) calculates the geometric standard deviation along
% dimension DIM of X.  Use a flag of 0 to normalise by factor (N-1), or a
% flag of 1 to normalise by factor N.
% 
% 
% NOTE: Class type checking and error handling are conducted within EXP,
% STD and LOG.
%
% 
% EXAMPLE:  X = 10*rand(5);
%                      geostd(X)
%                      ans =
%                     
%                         1.1858    1.8815    1.8029    4.1804    2.5704
% 
% 
%   Class support for input X:
%      float: double, single
% 
% 
%   See also GEOMEAN (stats toolbox), STD.
% 
% 
% $ Author: Richie Cotton $     $ Date: 2006/03/17 $


% Basic error checking of inputs
if nargin < 1
    error('geostd:notEnoughInputs', 'This function requires at least one input.');
elseif any(x(:) < 0)
    error(geostd:badData', 'All data values must be positive.');
end

% Setup default flag where required
if nargin < 2 || isempty(flag)
    flag = 1;
end

% If dimension is not specified, find first non-singleton dimension
if nargin < 3 || isempty(dim)
    dim = find(size(x) ~= 1, 1);
    if isempty(dim)
        dim = 1;
    end
end

% Turn off warnings regarding log of zero, since this is an artifact of the
% technique use to calculate the gsd
lozwarning = warning('off', 'MATLAB:log:logOfZero');

% Calculate geometric std dev using 
% "log of geometric std dev of data = arithmetic std dev of log of data"
gsd = exp(std(log(x), flag, dim));

% Reset warning value
warning(lozwarning);