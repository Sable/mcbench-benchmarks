function llh = GFM_llh( theta, tree )

% Evaluate the likelihood of data under the estimated GFM model
% This is *exactly* the same procedure for likelihood computation as in
% GFM_EM
%
% Syntax:
%   llh = GFM_llh( theta, tree )
%
%
% Input:
%   theta : Parameter cell for GFM model.
%
%   tree  : Wavelet tree from DWT2_TO_CELL
%
%
% Output:
%   llh   : Vector with log-likelihood for each direction and all trees

if size(theta, 1) ~= numel(tree)-1
    error('Wavelet transform must have the same size as theta');
end

L = length(tree) - 1;
M = numel( theta{1} );

% Naming convention:
% beta1 is beta_u
% beta2 is beta_{rho(u),u}

[no_rows, no_cols] = cellfun( @(x) size(x{1}), tree(2:end) );
[beta1, lh, cond_joint_probs] = deal( cell(L,1) );

for l = 1:L
    beta1{l} = ones(no_rows(l), no_cols(l), M);
    lh{l} = zeros(no_rows(l), no_cols(l));
    cond_joint_probs{l} = ones(no_rows(l), no_cols(l), M, M);
end

[beta2, prod_beta2, state_probs] = deal( beta1 );
[beta1_rep] = deal( cond_joint_probs );
llh = zeros(3, 1);

for d = 1:3
    for l = L:-1:1
        w{l} = repmat(tree{l+1}{d}, [1 1 M]);
        likelihood = normpdf( w{l}, 0, ...
            repmat(reshape(theta{l,3,d}, [1 1 M]), [no_rows(l) no_cols(l) 1]) );
        
        % Make sure numerically large coefficients doesn't evaluate to all
        % zeros
        idx = find( sum(likelihood, 3) == 0 );
        if ~isempty( idx )
            likelihood(idx) = 1/M;
        end
        
        state_probs{l} = repmat( reshape( theta{l,1,d}, [1 1 M] ), [no_rows(l) no_cols(l) 1] );
        
        % For the non-leaf nodes beta1 needs an additional factor
        if l < L
            % Compute beta2
            trans_probs{l+1} = repmat(reshape( theta{l+1,2,d}, [1 1 M M] ), [no_rows(l+1) no_cols(l+1) 1]);
            beta1_rep{l+1} = repmat( beta1{l+1}, [1 1 1 M] );
            state_probs_rep{l+1} = repmat( state_probs{l+1}, [1 1 1 M] );
            
            beta2_full = trans_probs{l+1} .* beta1_rep{l+1} ./ state_probs_rep{l+1};
            beta2{l+1} = squeeze( sum(beta2_full, 3) );
            
            % Product of beta2's with common parent
            prod_beta2{l} = ...
                beta2{l+1}(1:2:end, 1:2:end, :) .* ...
                beta2{l+1}(2:2:end, 1:2:end, :) .* ...
                beta2{l+1}(1:2:end, 2:2:end, :) .* ...
                beta2{l+1}(2:2:end, 2:2:end, :);
            
            % Unnormalized beta1
            tmp = prod_beta2{l} .* likelihood .* state_probs{l};
        else
            % Unnormalized beta1
            tmp = likelihood .* state_probs{l};
        end
        
        % Likelihood and beta1
        lh{l} = sum( tmp, 3 );
        beta1{l} = tmp ./ repmat( lh{l}, [1 1 M] );
    end
    
    % The total likelihood for this direction
    llh(d) = sum( cellfun(@(x) sum(log( max(x(:), eps) )), lh) );
end

end
