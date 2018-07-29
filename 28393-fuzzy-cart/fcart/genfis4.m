function fismat = genfis4(Xin, Xout, fistype, sig_par, varargin)

%GENFIS4 Generates a FIS using CART
%
%   Given separate sets of input and output data, GENFIS4 generates a fuzzy
%   inference system (FIS) using CART algorithm. GENFIS4 accomplishes this
%   by extracting a set of rules that models the data behavior. The rule
%   extraction method first uses TREEINFO to determine the number
%   of rules and membership functions for the antecedents and consequents.
%
%   FIS = GENFIS4(XIN, XOUT) returns a Sugeno-type FIS given input data XIN
%   and output data XOUT. The matrices XIN and XOUT have one column per FIS 
%   input and output, respectively.
%
%   FIS = GENFIS4(XIN, XOUT, TYPE) returns FIS of type specified by the
%   argument TYPE. It can take one of two values: 'mamdani' or 'sugeno'.
%
%   FIS = GENFIS4(XIN, XOUT, TYPE, SIGM_PAR) allows you to specify the
%   sigmoid parameters in the argument SIGM_PAR. The parameter is used to
%   form input membership function. The larger SIGM_PAR the closer
%   behaviour of fuzzy CART to behaviour of "crisp" CART. It should be
%   positive scalar or vector. The latter should have size equal to number
%   of FIS inputs. This argument also takes the value 'auto' in which case
%   GENFIS4 uses additional information containing in data set to calculate
%   SIGM_PAR. 
% 
%   FIS = GENFIS4(XIN, XOUT, TYPE, SIGM_PAR, VARARGIN) allows you to
%   specify options for the CART algorithm. Type HELP CLASSREGTREE and 
%   HELP TEST for a list of options that can be specified for the CART
%   algorithm.
%
%   Examples:
% 
%       Xin1 = 7 * rand(50, 1);
%       Xin2 = 20 * rand(50, 1) - 10;
%       Xin = [Xin1 Xin2];
%       Xout = 5 * rand(50, 1);
%       fis = genfis4(Xin, Xout);
%
%       fis = genfis4(Xin, Xout, 'mamdani', [10, 1]);
%       specifies the type of FIS and the sigmoid parameters desired.
%
%       fis = genfis4(Xin, Xout, 'mamdani', 'auto', {'minparent', 15}); 
%       specifies the type of FIS, the sigmoid parameters desired and CART 
%       options.
%
%   See also CLASSREGTREE, TEST, TREEINFO, GENFIS3, ANFISX

%   Per Konstantin A. Sidelnikov, 2009.

%%%%%%%%%%%%%%%%%%%%
% Some constants
%%%%%%%%%%%%%%%%%%%%

% Number of standard deviations (can be changed)
NSTD = 1;
% Area under the gauss curve in the 
% [mu - NSTD * sigma, mu + NSTD * sigma]
AREA = erf(NSTD / sqrt(2));
% Scaling factor 
SCALE = log((1 + AREA) / (1 - AREA)) / NSTD;

%%%%%%%%%%%%%%%%%%%%
% Number of input arguments checking
%%%%%%%%%%%%%%%%%%%%

if nargin < 2
    error('FuzzyLogic:missingparams', ...
        'genfis4 requires input and output data to build a FIS.');
end

if nargin < 3
    fistype = 'sugeno';
end

if nargin < 4
    sig_par = 'auto';
end

% hardcoded for now
in_mftype = 'sigmf';
out_mftype = 'gaussmf';

%%%%%%%%%%%%%%%%%%%%%%%%%
% IO checking
%%%%%%%%%%%%%%%%%%%%%%%%%

% Check Xin, Xout
[numData, numInp] = size(Xin);
[numData2, numOutp] = size(Xout);

if numData ~= numData2
    % There's a mismatch in the input and output data matrix dimensions
    if numData == numOutp
        % The output data matrix should have been transposed, we'll fix it
        Xout = Xout';
        numOutp = numData2;
    else
        error('FuzzyLogic:dimensionmismatch', ...
            'Mismatched input and output data matrices.');
    end
end

if numOutp > 1
    error('FuzzyLogic:outputmismatch', ...
        'Output data must be a vector.');
end

%%%%%%%%%%%%%%%%%%%%
% Checking sig_par
%%%%%%%%%%%%%%%%%%%%

% Convert sig_par (if necessary) to numeric array
arrayNaN = NaN(1, numInp);
if ~isnumeric(sig_par)
    if ~isequal(sig_par, 'auto')
        error('FuzzyLogic:sigmoid', ...
            'Set sigmoid parameter to ''auto'' or a value greater than 0');
    end
    sig_par = arrayNaN;
elseif ~isscalar(sig_par)
    tmp = arrayNaN;
    tmp(1 : length(sig_par)) = sig_par;
    sig_par = tmp;
else
    sig_par = repmat(sig_par, 1, numInp);
end 
% Avoid negative sig_par
sig_par = abs(sig_par);
% Length of sig_par must be the same as number of inputs
if length(sig_par) ~= numInp
    error('FuzzyLogic:sigmoid', ...
        ['Set number of sigmoid parameters to ', ...
        '1 or %d (number of inputs)'], numInp);
end

%%%%%%%%%%%%%%%%%%%%
% Creating tree
%%%%%%%%%%%%%%%%%%%%
ti = treeinfo(Xin, Xout, varargin{:});

n_node = numel(ti.node);
n_leaf = numel(ti.leaf);

in_mf = zeros(1, n_node);

%%%%%%%%%%%%%%%%%%%%%%
% Building FIS
%%%%%%%%%%%%%%%%%%%%%

% Initialize a FIS
str = sprintf('%s%g%g', fistype, numInp, numOutp);
fismat = newfis(str, fistype);

% Loop through and add inputs
for ind = 1 : numInp    
    fismat = addvar(fismat, ...
        'input', ['in' num2str(ind)], minmax(Xin(:, ind)'));
end

% Loop through and add mf's
for ind = 1 : n_node       
    var = ti.node(ind).variable;
    cut = ti.node(ind).cutpoint;
    s = ti.node(ind).sample;        
    mfparams = computemfparams(in_mftype, Xin(s, var), ...
        cut, sig_par(var), SCALE);
    
    fismat = addmf(fismat, 'input', var, ...
        ['larger', num2str(ind)], in_mftype, mfparams);
    
    in_mf(ind) = length(fismat.input(var).mf);
end

% Add output
fismat = addvar(fismat, 'output', 'out', minmax(Xout'));

switch fistype  
    case 'sugeno'
        % Loop through and add mf's        
        for ind = 1 : n_leaf         
            s = ti.leaf(ind).sample;
            mfparams = computemfparams('linear', Xin(s, :), Xout(s));
            
            fismat = addmf(fismat, 'output', 1, ...
                ['class', num2str(ind)], 'linear', mfparams);           
        end
    case 'mamdani'        
        % Loop through and add mf's
        for ind = 1 : n_leaf  
            s = ti.leaf(ind).sample;
            mfparams = computemfparams(out_mftype, [], Xout(s));
            
            fismat = addmf(fismat, 'output', 1, ...
                ['class', num2str(ind)], out_mftype, mfparams);
        end
    otherwise
        error('FuzzyLogic:unknownfistype', ...
            'Unknown fistype specified');    
end

% Create rules
rulelist = cell(n_leaf, 4);
for ind = 1 : n_leaf   
    n = ti.branch(ind).nodes;
    e = ti.branch(ind).ineqs;
    
    var = [ti.node(n).variable];
        
    rulelist{ind, 1} = [var; in_mf(n) .* e];
    rulelist{ind, 2} = ind;
    rulelist{ind, 3} = 1;
    rulelist{ind, 4} = 1;
end

fismat = addrulex(fismat, rulelist);

function mfparams = computemfparams(mf, X, y, sig_par, scale)
%   This subfunction computes parameters of input and 
%   output membership functions dependeding on mf's value.

switch mf
    case 'sigmf'
        % NaN's value of sig_par means its automatic calculation
        if isnan(sig_par)
            sigma = std(X);
            sig_par = scale / sigma;
        end
        mfparams = [sig_par, y];
    case 'gaussmf'
        sigma = std(y);
        % Check if y is a scalar or consists of identical elements
        if sigma == 0
            sigma = sqrt(eps);
        end
        c = mean(y);
        mfparams = [sigma, c];
    case 'linear'
        numData = size(X, 1);
        A = [X, ones(numData, 1)];
        % Using pinv instead of ldivide avoids
        % warning if A is close to singular
        mfparams = (pinv(A) * y)';
    otherwise
        error('FuzzyLogic:invalidmftype', ...
            'Unknown type of membership function specified.');
end

function pr = minmax(p)
%MINMAX Ranges of matrix rows.
%
%  Syntax
%
%    pr = minmax(p)
%
%  Description
%
%    MINMAX(P) takes one argument,
%      P - RxQ matrix.
%    and returns the Rx2 matrix PR of minimum and maximum values
%    for each row of P.
%
%    Alternately, P can be an MxN cell array of matrices.  Each matrix
%    P{i,j} should have Ri rows and Q columns.  In this case, MINMAX returns
%    an Mx1 cell array where the mth matrix is an Rix2 matrix of the
%    minimum and maximum values of elements for the matrics on the
%    ith row of P.
%
%  Examples
%
%    p = [0 1 2; -1 -2 -0.5]
%    pr = minmax(p)
%
%    p = {[0 1; -1 -2] [2 3 -2; 8 0 2]; [1 -2] [9 7 3]};
%    pr = minmax(p)

if iscell(p)
    m = size(p, 1);
    pr = cell(m, 1);
    for i = 1 : m
        pr{i} = minmax([p{i, :}]);
    end
elseif isa(p, 'double')
    pr = [min(p, [], 2), max(p, [], 2)];
else
    error('Argument has illegal type.');
end