function y = truerand(varargin)
% TRUERAND Returns truly random integers using random.org's Random Integer
%   Generator. According to random.org, the numbers are generated based on
%   atmospheric noise and skew-corrected to generate uniform numbers. The
%   generated numbers have been shown to pass the NIST tests for RNGs.
%
%   The range of numbers is -1e9 to 1e9 and the maximum number of values
%   that can be generated is 10,000
%
% USAGE:
%  truerand(rows,cols,min,max) returns a matrix of size rows-by-cols with
%  random integers between min and max.
%  truerand(n,min,max) returns an n by 1 vector 
%  truerand(n, m) uses the default values min = 1, max = 100
%  truerand(n) and truerand
%
% EXAMPLES:
%  y = truerand
%  y = truerand(9)
%  y = truerand(6,6)
%  y = truerand(5,1,20)
%  y = truerand(3, 4, 15, 30)
%
% For more information visit random.org

m = 1;
n = 1;
min = 1;
max = 100;
seed = 'new'; % New implies new random numbers - they will not be the same with each run



if nargin > 0
    m = varargin{1};
end
if nargin == 2 || nargin == 4
    n = varargin{2};
end

if m*n>=10000
    error('The maximum number of values requested must be no greater than 10000')
end

if min < -1e9 || max > 1e9
    error('The range of values must lie in [-1e9, 1e9]')
end


if nargin == 3 || nargin == 4
    [min,max] = varargin{end-1:end};
end
        
url = sprintf('http://www.random.org/integers/?num=%d&min=%d&max=%d&col=1&base=10&format=plain&rnd=%s',...
              m*n, min, max, seed);
data = urlread(url);
y = reshape(str2num(data),m,n); %#ok<ST2NM>

