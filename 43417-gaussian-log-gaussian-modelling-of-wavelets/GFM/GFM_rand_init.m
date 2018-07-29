function theta = GFM_rand_init( tree, M, min_prob, min_std )

% Initial values for GFM EM algorithm
% Use the 'small' EM algorithm of Fan & Xia to initialize the 'big' EM
% algorithm of Crouse et al/Durand et al.
%
% Syntax:
%   theta = GFM_rand_init( tree, M, min_prob, min_std )
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
% See also: GFM_INIT, GFM_EM_WRAPPER, GFM_EM

L = length(tree) - 1;
D = length(tree{2});

% Initialize output
theta = cell( L, 3, D );

for l = 1:L
    for d = 1:D
		% State probs
        p = max( min_prob, rand(1,2) );
        theta{l, 1, d} = p / sum(p);
        
		if l > 1
			% Trans probs
    		p = max( min_prob, rand(2) );
    		theta{l, 2, d} = p ./ repmat( sum(p), [M 1] );

			% Update state probs to be consistent with the trans probs
			theta{l,1,d} = theta{l-1,1,d} * theta{l,2,d}';
		end
        
		% Standard devs
        theta{l, 3, d} = max( min_std, rand(1,M)*std(tree{l+1}{d}(:)) );
    end
end

end
