function pattern = elementaryCellularAutomata(rule, n, width, randfrac)
%elementaryCellularAutomata Elementary 1D cellular automaton patterns
%
%   PATTERN = elementaryCellularAutomata(RULE, NITER), where NITER is a
%   scalar, returns an NITER x 2*NITER+1 matrix whose entries are all 0 or
%   1. The I'th row of the matrix contains the state of the elementary 1D
%   cellular automaton at iteration I-1, counting the initial state as
%   iteration 0. The integer RULE specifies the rule to use as set out at
%   http://mathworld.wolfram.com/ElementaryCellularAutomaton.html.
%
%   The initial state is all zeros except for a 1 at element NITER+1 (the
%   central element) of the CA.
%
%   PATTERN = elementaryCellularAutomata(RULE, NITER, WID), where WID is a
%   scalar, returns an NITER x WID matrix. The array of cells is taken to
%   be circular, so that PATTERN(I+1,I) depends on PATTERN{(I,WID), (I,1)
%   and (I,2)}. Similarly, PATTERN(I+1,WID) depends on PATTERN{(I,WID-1),
%   (I,WID) and (I,1)}. This only matters if WID < 2*NITER+1 and RULE is
%   such that the pattern propagates outwards, so reaching the boundaries
%   of the array.
%
%   This wraparound allows long, thin patterns to be generated if an
%   appropriate rule is chosen. All patterns with a fixed width will be
%   periodic, unless some random noise is added.
%
%   The state on the first iteration is all zeros except for a 1 at element
%   floor((WID+1)/2) of the CA.
%
%   PATTERN = elementaryCellularAutomata(RULE, NITER, START) where START is
%   a 1 x WID row vector containing only the values 0 and 1, is as above
%   except that the initial state is given by the entries in START. Thus on
%   exit, PATTERN(1,:) is equal to START.
%
%   PATTERN = elementaryCellularAutomata(RULE, NITER, WIDSTART, FNOISE) is
%   as above except that noise is added to the process. WIDSTART can be
%   either a scalar giving the width or a vector giving the start state; an
%   empty matrix is equivalent to 2*NITER+1. FNOISE is a number from 0 to 1
%   giving the probability that any given cell will be set to the wrong
%   state (the complement of the state given by the rule) on any one
%   iteration.
%
%   Example
%   -------
%       % show 50 rows of each pattern
%       for rule = 0:255
%           pattern = elementaryCellularAutomata(rule, 50);
%           imshow(pattern); pause;
%       end

%   Copyright 2010 David Young

% check arguments and supply defaults
error(nargchk(2, 4, nargin));
validateattributes(rule, {'numeric'}, {'scalar' 'integer' 'nonnegative' '<=' 255}, ...
    'elementaryCellularAutomata', 'RULE');
validateattributes(n, {'numeric'}, {'scalar' 'integer' 'positive'}, ...
    'elementaryCellularAutomata', 'N');
if nargin < 3 || isempty(width)
    width = 2*n-1;
elseif isscalar(width)
    validateattributes(width, {'numeric'}, {'integer' 'positive'}, ...
        'elementaryCellularAutomata', 'WIDTH');
else
    validateattributes(width, {'numeric' 'logical'}, {'binary' 'row'}, ...
        'elementaryCellularAutomata', 'START');
end
if nargin < 4 || isempty(randfrac)
    dorand = false;
else
    validateattributes(randfrac, {'double' 'single'}, {'scalar' 'nonnegative' '<=' 1}, ...
        'elementaryCellularAutomata', 'FNOISE');
    dorand = true;
end

% set up machine
if isscalar(width)
    patt = ones(1, width);
    patt(floor((width+1)/2)) = 2;
else
    patt = width + 1;  % change 0,1 to 1,2 so can use sub2ind
    width = length(patt);
end

% unpack rule
rulearr = (bitget(rule, 1:8) + 1);

% initialise output array
pattern = zeros(n, width);

% iterate to generate rest of pattern
for i = 1:n
    pattern(i, :) = patt;   % record current state in output array
    
    % core step: apply CA rules to propagate to next 1D pattern
    ind = sub2ind([2 2 2], ...
        [patt(2:end) patt(1)], patt, [patt(end) patt(1:end-1)]);
    patt = rulearr(ind);
    
    %optional randomisation
    if dorand
        flip = rand(1, width) < randfrac;
        patt(flip) = 3 - patt(flip);
    end
end

% change symbols from 1 and 2 to 0 and 1
pattern = pattern-1;
end
