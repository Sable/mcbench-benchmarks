function tree = GFM_simulation( theta, sz )

% Simulation from a GFM model
%
% Syntax:
%   tree = gfm_simulation( theta, sz )
%
% Input:
%   theta : Cell with parameters.
%
%   sz    : Size of the smallest high pass subband.
%
%
% Output:
%   tree  : Tree with simulated high pass subbands and empty low pass.

if isscalar( sz )
    sz = sz * ones(1,2);
end

level = size(theta,1) + 1;
no_dir = size(theta,3);
M = numel(theta{1});

% Prepare tree
[hidden, tree] = deal( cell(1, level) );
[hidden{2:level}, tree{2:level}] = deal( cell(1, no_dir) );

% Simulation
for l = 2:level
    cur_sz = 2^(l-1)*sz;
    no_w = prod( cur_sz );

    for d = 1:no_dir
        % Find the mixture component for each observation
        U = rand( no_w, 1 );
        
        if l == 2
            % Root mixtures
            hidden_cdf = repmat( [0 cumsum(theta{l-1,1,d})], no_w, 1 );
        else
            % In the tree the mixture probs depends on the parent
            parents = kron( reshape(hidden{l-1}{d}, cur_sz/2), ones(2) );
            hidden_cdf = [ zeros(no_w,1) cumsum( theta{l-1,2,d}(:,parents(:)) )' ];
        end
        
        hidden_idx = hidden_cdf >= repmat( U, 1, M+1 );
        hidden{l}{d} = reshape( M + 1 - sum(hidden_idx, 2), cur_sz );
        
        % Mix the mixtures
        tree{l}{d} = theta{l-1,3,d}(hidden{l}{d}) .* randn( cur_sz );
    end
end

end
