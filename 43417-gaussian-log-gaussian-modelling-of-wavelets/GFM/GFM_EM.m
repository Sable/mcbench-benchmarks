function [theta, llh] = GFM_EM( theta, tree, d, min_prob, min_std, max_itr, conv_thres, conv )

% EM algorithm for HMM model
% Parameter estimation of the multiscale Hidden Markov Model using the EM
% algorithm of Durand et al (to avoid numerical underflow from the
% algorithm of Crouse et al).
%
% Syntax:
%   [theta, ll] = GFM_EM( theta, tree, d, min_prob, min_std, max_itr, conv_thres, conv )
%
% Input:
%   theta      : Current parameters.
%
%   tree       : Cell with wavelet coefficients.
%
%   d          : Direction.
%
%   min_prob   : Minimum value for the probabilities.
%
%   min_std    : Minimum value for the standard deviations.
%
%   max_itr    : The maximum number of iterations
%
%   conv_thres : Convergence threshold for the log-likelihood function
%
%   conv       : How should CONV_THRES be applied: 'absolute' or 'relative'
%
%
% Output:
%   theta      : Updated parameters.
%
%   llh        : Log-likelihood of input parameters.
%
%
% See also: GFM_EM_WRAPPER, GFM_INIT


% --------------------------------------------------------------------
%                                                Initialize parameters
% --------------------------------------------------------------------

count = 1;
ll_increase = Inf;
llh = zeros(max_itr, 1);

rel_conv = strcmpi(conv, 'relative');

L = length(tree) - 1;
M = numel( theta{1} );

% Naming convention:
% beta1 is beta_u
% beta2 is beta_{rho(u),u}

[no_rows, no_cols] = cellfun( @(x) size(x{1}), tree(2:end) );
[beta1, lh, cond_joint_probs, w] = deal( cell(L,1) );

for l = 1:L
    beta1{l} = ones(no_rows(l), no_cols(l), M);
    lh{l} = zeros(no_rows(l), no_cols(l));
    cond_joint_probs{l} = ones(no_rows(l), no_cols(l), M, M);
    
    w{l} = repmat(tree{l+1}{d}, [1 1 M]);
end

[beta2, prod_beta2, cond_state_probs, state_probs, alpha, xi] = deal( beta1 );
[beta1_rep] = deal( cond_joint_probs );


while (count <= max_itr) && (ll_increase > conv_thres)
    % Inform user
    backsp = repmat( '\b', 1, numel(num2str(count-1)) );
    fprintf( [backsp '%u'], count);
    
    % --------------------------------------------------------------------
    %                                                               E step
    % --------------------------------------------------------------------
    
    % Upward recursion ---------------------------------------------------
    
    for l = L:-1:1
        likelihood = normpdf( w{l}, 0, ...
            repmat(reshape(theta{l,3,d}, [1 1 M]), [no_rows(l) no_cols(l) 1]) );
        
        % If a coefficient is so large that all likelihoods are zero at
        % this point, it is considered equally (un)likely for all them all
        idx = find( sum(likelihood, 3) == 0 );
        if ~isempty( idx )
            likelihood(idx, :) = 1/M;
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
            beta2_rep{l+1} = repmat( beta2{l+1}, [1 1 1 M] );
            
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
    
    
    % Downward recursion -------------------------------------------------
    
    cond_state_probs{1} = beta1{1};
    beta1_rep{1} = repmat( beta1{1}, [1 1 1 M] );
    
    for l = 2:L
        xi{l-1} = alpha{l-1} .* beta1{l-1};
        idx_col = kron( 1:no_cols(l-1), ones(1,M) );
        idx_row = kron( 1:no_rows(l-1), ones(1,M) );
        xi_kron = xi{l-1}( idx_col, idx_row, : );
        xi_rep = repmat( xi_kron, [1 1 1 M] );
        
        full_alpha = permute(trans_probs{l}, [1 2 4 3]) .* xi_rep ...
            ./ ( beta2_rep{l} .* permute(state_probs_rep{l}, [1 2 4 3]) );
        
        alpha{l} = squeeze(sum( full_alpha, 3 ));
        
        cond_joint_probs{l} = full_alpha .* permute(beta1_rep{l}, [1 2 4 3]);
        
        cond_state_probs{l} = squeeze( sum(cond_joint_probs{l}, 3) );
    end
    
    
    % --------------------------------------------------------------------
    %                                                               M step
    % --------------------------------------------------------------------
    
    for l = 1:L
        % State probs
        theta{l,1,d} = max( min_prob, squeeze(mean(mean( cond_state_probs{l} ))) )';
        theta{l,1,d} = theta{l,1,d} / sum( theta{l,1,d} );
        
        % Transition probs
        if l > 1
            cond_trans_probs = squeeze(mean(mean( cond_joint_probs{l} ))) ./ repmat( theta{l-1,1,d}', [1 M] );
            
            theta{l,2,d} = max( min_prob, cond_trans_probs' );
            theta{l,2,d} = theta{l,2,d} ./ repmat( sum(theta{l,2,d}), M, 1 );
        end
        
        % Variances
        theta{l,3,d} = squeeze(mean(mean( w{l}.^2 .* cond_state_probs{l} )))' ./ theta{l,1,d};
        theta{l,3,d} = max( min_std, sqrt(theta{l,3,d}) );
    end
    
    
    % --------------------------------------------------------------------
    %                                               Compute log-likelihood
    % --------------------------------------------------------------------
    
    % Likelihood (with new parameters) is a by-product of the upward recursion
    for l = L:-1:1
        likelihood = normpdf( w{l}, 0, ...
            repmat(reshape(theta{l,3,d}, [1 1 M]), [no_rows(l) no_cols(l) 1]) );
        
        idx = find( sum(likelihood, 3) == 0 );
        if ~isempty( idx )
            likelihood(idx, :) = 1/M;
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
            beta2_rep{l+1} = repmat( beta2{l+1}, [1 1 1 M] );
            
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
    
    llh(count) = sum( cellfun(@(x) sum(log(x(:))), lh) );
    
    
    % --------------------------------------------------------------------
    
    % Update conditions for while loop
    if count > 1
        ll_increase = abs( llh(count, 1) - llh(count-1, 1) );
        
        if rel_conv
            ll_increase = ll_increase / abs(llh(count-1));
        end
    end
    
    count = count + 1;
end


llh = llh(1:count-1);

end
