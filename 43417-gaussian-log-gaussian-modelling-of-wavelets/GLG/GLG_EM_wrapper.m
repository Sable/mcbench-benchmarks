function FitInfo = GLG_EM_wrapper( theta, tree, varargin )

% Fit GLG model to 1D wavelet tree with composite EM algorithms
% Run the two EM algorithms for the GLG model until effective convergence.
%
% Syntax:
%   FitInfo = GLG_EM_wrapper( theta, tree, ... )
%
% Input:
%   theta      : Parameter array
%
%   tree       : Wavelet tree from DWT2_TO_CELL
%
%
% The optional arguments are specified as NAME, VALUE.
%
%   conv_thres : Convergence threshold for the log-likelihood function
%
%   conv       : How should CONV_THRES be applied: 'absolute' og 'relative'
%                Default: 'absolute'
%
%   max_itr    : The maximum number of iterations
%                Default: 50
%
%   nodes      : The number of nodes used in quadrature rule
%                Default: 20
%
%   noise_dev  : Standard dev of noise; 0 if not relevant.
%                Default: 0
%
%
% Output:
%   FitInfo    : Structure with model, initial model and likelihood
%
%
% See also: EM_ROOT, EM_TREE


% --------------------------------------------------------------------
% 													Set default values
% --------------------------------------------------------------------

p = inputParser;

p.addRequired( 'theta' );
p.addRequired( 'tree' );

p.addOptional( 'conv_thres', 0.01, @isnumeric );
p.addOptional( 'conv', 'absolute', @ischar );
p.addOptional( 'max_itr', 50, @isnumeric );
p.addOptional( 'nodes', 20, @isnumeric );
p.addOptional( 'noise_dev', 0, @isnumeric );

parse( p, tree, theta, varargin{:} );

conv_thres = p.Results.conv_thres;
conv       = p.Results.conv;
max_itr    = p.Results.max_itr;
nodes      = p.Results.nodes;
noise_dev  = p.Results.noise_dev;


% --------------------------------------------------------------------
% 													 Initialize output
% --------------------------------------------------------------------

no_levels = length(tree)-1;
no_dir = size( theta, 3 );

ll = cell(no_levels, no_dir);

% Initialize output
FitInfo = struct(...
    'init_model', theta, ...
    'model', zeros(no_levels, 5, no_dir), ...
    'll', [] ...
    );


% --------------------------------------------------------------------
%                                    Run EM algorithm on the top level
% --------------------------------------------------------------------

% Inform user
fprintf('Running EM algorithm...\n');

if no_dir > 1
    fprintf(repmat( ' ', 1, 10 ));
    
    num_itr_space = numel(num2str(max_itr))-numel(num2str(no_dir))+3;
    
    itr_space = repmat( ' ', 1, num_itr_space );
    for d = 1:no_dir
        fprintf( ['Direction %u' itr_space], d );
    end
    
    fprintf('\n');
end

fprintf('Level 1   ');

for d = 1:no_dir
    w = tree{2}{d}(:);

    % Inform user
    fprintf('Iteration:  ');
    
    % Run EM algorithm
    [theta, ll{1,d}] = EM_root( theta, w, d, nodes, max_itr, noise_dev, conv_thres, conv );
    
    % Prepare for iteration count for next direction
    if no_dir > 1
        count = length(ll{1,d});
        fprintf( repmat(' ', 1, numel(num2str(max_itr))-numel(num2str(count))+2) );
    end
end


% --------------------------------------------------------------------
%                             Run EM algorithm on the remaining levels
% --------------------------------------------------------------------

for l = 2:no_levels
    fprintf('\nLevel %u   ', l);
    
    for d = 1:no_dir
        % Arrange coefficients
        w_parent = tree{l}{d}(:);
        
        % For images!
        w_child = zeros( numel(w_parent), 4 );
        w_child(:,1) = reshape( tree{l+1}{d}(1:2:end, 1:2:end), 1, [] );
        w_child(:,2) = reshape( tree{l+1}{d}(1:2:end, 2:2:end), 1, [] );
        w_child(:,3) = reshape( tree{l+1}{d}(2:2:end, 1:2:end), 1, [] );
        w_child(:,4) = reshape( tree{l+1}{d}(2:2:end, 2:2:end), 1, [] );
        
        % Inform user
        fprintf('Iteration:  ');
        
        % Run EM algorithm
        [theta, ll{l,d}] = EM_tree( theta, w_parent, w_child, l, d, nodes, max_itr, noise_dev, conv_thres, conv );
        
        % Prepare for iteration count for next direction
        if no_dir > 1
            count = length(ll{l,d});
            fprintf( repmat(' ', 1, numel(num2str(max_itr))-numel(num2str(count))+2) );
        end
    end
end

fprintf('\n\n');

% Final model
FitInfo.model = theta;
FitInfo.ll = ll;

% Test if any likelihood function has decreased
[row, col] = find(cellfun( @(ll) any(ll(2:end) < ll(1:end-1)), ll ));

if ~isempty( row )
    fprintf('Likelihood functions decreased on level and direction:\n');
    disp( [row col] );
end

end
