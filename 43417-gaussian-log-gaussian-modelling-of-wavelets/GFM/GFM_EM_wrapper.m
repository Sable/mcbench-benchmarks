function FitInfo = GFM_EM_wrapper( theta, tree, varargin )

% Fit GFM model to a wavelet tree using the EM algorithm
%
% Syntax:
%   FitInfo = EM_wrapper( theta, tree, ... )
%
% Input:
%   theta      : Parameter cell
%
%   tree       : Wavelet tree from DWT2_TO_CELL
%
%
% The optional arguments are specified as NAME, VALUE.
%
%   conv_thres : Convergence threshold for the log-likelihood function
%                Default: 0.01
%
%   conv       : How should CONV_THRES be applied: 'absolute' or 'relative'
%                Default: 'absolute'
%
%   max_itr    : The maximum number of iterations
%                Default: 100
%
%   min_prob   : Minimum value for the probabilities.
%                Default: 1e-2
%
%   min_std    : Minimum value for the standard deviations.
%                Default: 1e-3
%
%
% Output:
%   FitInfo    : Structure with model, initial model and likelihood
%
%
% See also: GFM_EM


% --------------------------------------------------------------------
% 													Set default values
% --------------------------------------------------------------------

p = inputParser;

p.addRequired( 'theta' );
p.addRequired( 'tree' );

p.addOptional( 'conv_thres', 0.01, @isnumeric );
p.addOptional( 'conv', 'absolute', @ischar );
p.addOptional( 'max_itr', 100, @isnumeric );
p.addOptional( 'min_std', 1e-3, @isnumeric );
p.addOptional( 'min_prob', 1e-2, @isnumeric );

parse( p, tree, theta, varargin{:} );

conv_thres = p.Results.conv_thres;
conv       = p.Results.conv;
max_itr    = p.Results.max_itr;
min_std    = p.Results.min_std;
min_prob   = p.Results.min_prob;


% --------------------------------------------------------------------
% 													 Initialize output
% --------------------------------------------------------------------

no_dir = size( theta, 3 );

% Initialize output
FitInfo = struct(...
    'init_model', {theta}, ...
    'model', {theta}, ...
    'll', {cell(no_dir, 1)} ...
    );

ll = cell(no_dir, 1);

% --------------------------------------------------------------------
%                                                     Run EM algorithm
% --------------------------------------------------------------------

% Inform user
fprintf('Running EM algorithm...\n');

if no_dir > 1
    num_itr_space = numel(num2str(max_itr))-numel(num2str(no_dir))+3;
    
    itr_space = repmat( ' ', 1, num_itr_space );
    for d = 1:no_dir
        fprintf( ['Direction %u' itr_space], d );
    end
    
    fprintf('\n');
end


for d = 1:no_dir

    % Inform user
    fprintf('Iteration:  ');
    
    % Run EM algorithm
    [theta, ll{d}] = GFM_EM( theta, tree, d, min_prob, min_std, max_itr, conv_thres, conv );
    
    % Prepare for iteration count for next direction
    if no_dir > 1
        count = length(ll{d});
        fprintf( repmat(' ', 1, numel(num2str(max_itr))-numel(num2str(count))+2) );
    end
end

fprintf('\n\n');


% --------------------------------------------------------------------
%                                                             Finalize
% --------------------------------------------------------------------

% Final model
FitInfo.model = theta;
FitInfo.ll = ll;

% Test if any likelihood function has decreased
ll_test = cellfun( @(ll) any(ll(2:end) < ll(1:end-1)), FitInfo.ll );

if any( ll_test(:) )
    fprintf( 'Likelihood decreased at direction:\n');
    disp( find(ll_test) );
end

end
