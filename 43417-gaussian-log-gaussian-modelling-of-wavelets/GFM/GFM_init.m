function theta = GFM_init( tree, M, min_prob, min_std )

% Initial values for GFM EM algorithm
% Use the 'small' EM algorithm of Fan & Xia to initialize the 'big' EM
% algorithm of Crouse et al/Durand et al.
%
% Syntax:
%   theta = GFM_init( tree, M, min_prob, min_std )
%
% Input:
%   tree  : Wavelet transform from DWT2_TO_TREE with L levels and D
%           dimensions
%
%   M     : The number of mixtures.
%
%	min_p : Mininimum value of the probabilities
%
%	min_s : Mininimum value of the standard devs
%
%
% Output:
%   theta : L-by-3-by-D cell with parameters. For the third dimension row l 
%           are the parameters for level l:
%           state probs, transition probs, standard deviations
%
%
% See also: GFM_EM_WRAPPER, GFM_EM

L = length(tree) - 1;
D = length(tree{2});

if numel(tree{2}) == 1
    dim = 1;
else
    dim = 2;
end

% Initialize output
theta = cell( L, 3, D );


% --------------------------------------------------------------------
% 												   Horizontal scanning
% --------------------------------------------------------------------

% Turn off warnings about EM algorithm not converging
s = warning('off', 'stats:gmdistribution:FailedToConverge');

% Fit M component mixture model to each level
for l = 1:L
    for d = 1:D
        obj = gmdistribution.fit( tree{l+1}{d}(:), M, 'CovType', 'diagonal', 'Regularize', min_std );
        
        p = max( min_prob, obj.PComponents );
        theta{l, 1, d} = p / sum(p);
        
        theta{l, 3, d} = max( min_std, sqrt(reshape(obj.Sigma, [1 M])) );
    end
end

% Turn warnings on
warning(s);


% --------------------------------------------------------------------
% 													 Vertical counting
% --------------------------------------------------------------------

% The estimation of Fan & Xia only works for M == 2
if M > 2
    [theta{2:end,2,:}] = deal( ones(M)/M );
    
    return
end

T = zeros(L, D);
S = tree;

% Compute the numbers for estimating transition probs
for l = 1:L
    for d = 1:D
        T_numerator = prod(theta{l,3,d})^2 * 2*log(theta{l,3,d}(2)/theta{l,3,d}(1));
        T_denominator = theta{l,3,d}(2)^2 - theta{l,3,d}(1)^2;
        
        T(l,d) = sqrt( T_numerator / T_denominator );
        
        S{1+l}{d} = abs(tree{1+l}{d}) >= T(l,d);
        
        % Estimate transition probs
        if l >= 2
            parent = kron( S{l}{d}, ones(2,dim) );
            child = S{l+1}{d};
            
            for n = 0:1
                for m = 0:1
                    count_common = (parent == n) .* (child == m);
                    
                    theta{l,2,d}(m+1,n+1) = sum(count_common(:)) / sum(parent(:) == n );
                end
            end
            
            theta{l,2,d} = max( min_prob, theta{l,2,d} );
            theta{l,2,d} = theta{l,2,d} ./ repmat( sum(theta{l,2,d}), M, 1 );
            
            % Update state probs to be consistent with the trans probs
            theta{l,1,d} = theta{l-1,1,d} * theta{l,2,d}';
        end
        
    end
end

end
