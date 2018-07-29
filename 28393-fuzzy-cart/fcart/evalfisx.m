function [output, IRR, ORR, ARR] = evalfisx(input, fis, numofpoints)
%EVALFISX Perform fuzzy inference calculations.
%
%   See evalfis for syntax and explanation.
% 
%   It is completely based on MATLAB's evalfis 
%   with some modifications, so it's compatible
%   with extendent fuzzy rule structure.
% 
%   Compare also code of this function
%   with code of the original evalfis.
% 
%   Example:
%   load carsmall;
%   fis = genfis4([Weight, Displacement], Acceleration, 'mamdani');
%   out = evalfisx([2000 100; 2000 200; 2000 300], fis);

%   Per Konstantin A. Sidelnikov, 2009.

if nargin < 2
   error('Need at least two inputs');  
end

% Check inputs
if ~isfis(fis)
   error('The second argument must be a FIS structure.');
elseif strcmpi(fis.type,'sugeno') && ~strcmpi(fis.impMethod, 'prod')
   warning('Fuzzy:evalfisx:ImplicationMethod', ...
       'Implication method should be "prod" for Sugeno systems.');
end

[M, N] = size(input);
Nin = getfisx(fis, 'numinputs');
if M == 1 && N == 1
   input = repmat(input, 1, Nin);
elseif M == Nin && N ~= Nin
   input = input.';
elseif N ~= Nin
   error(['The first argument should have as many columns as input', ...
       'variables and\nas many rows as independent sets of input values.']);
end

% Check the fis for empty values
checkfisx(fis);

% Issue warning if inputs out of range
inRange = getfisx(fis, 'inRange');
InputMin = min(input, [], 1);
InputMax = max(input, [], 1);
if any(InputMin(:) < inRange(:, 1)) || any(InputMax(:) > inRange(:, 2))
   warning('Fuzzy:evalfisx:InputOutOfRange', ...
       'Some input values are outside of the specified input range.');
end

% Compute output
if nargin == 2
   numofpoints = 101;
end

[output, IRR, ORR, ARR] = evalfisxmex(input, fis, numofpoints);