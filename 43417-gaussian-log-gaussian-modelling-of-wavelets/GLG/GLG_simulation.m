function tree = GLG_simulation( theta, sz )

% Simulation from a GLG model
%
% Syntax:
%   tree = glg_simulation( theta, sz )
%
%
% Input:
%   theta : Matrix with parameters.
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

% Prepare tree
[hidden, tree] = deal( cell(1, level) );
[hidden{2:level}, tree{2:level}] = deal( cell(1, no_dir) );

% Simulation
for l = 2:level
    cur_sz = 2^(l-2)*sz;
    
    for d = 1:no_dir
        
        if l == 2
            % In the top the hidden distribution is given
            hidden{l}{d} = theta(l-1,1,d) + theta(l-1,2,d)*randn( cur_sz );
        else
            % In the tree the mixture probs depends on the parent
            hidden{l}{d} = theta(l-1,3,d) + theta(l-1,4,d)*kron( hidden{l-1}{d}, ones(2) ) ...
                + theta(l-1,5,d)*randn( cur_sz );
        end
        
        tree{l}{d} = sqrt(exp(hidden{l}{d})) .* randn( cur_sz );
        tree{l}{d} = hidden{l}{d} + 0.001*randn( cur_sz );
    end
end

end
