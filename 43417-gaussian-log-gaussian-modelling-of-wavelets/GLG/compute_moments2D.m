function M = compute_moments2D( T )

% Compute moments of noiseless wavelet coefficients
% The moments used for parameter estimation in the GLG model are computed.
%
% Syntax:
%   M = compute_moments2D( T )
%
% Input:
%   T : Cell from DWT2_TO_CELL.
%
% Output:
%   M : L-by-4-by-3 matrix where L is the number of levels in the wavelet
%       transform and the (l+1)'th row is
%       eta_l^(2), eta_l^(4), eta_l^(2,2), xi_l^(2,2)
%       The third dimension is the directional subband (H, V, D)

% Allocate output
no_highpass = length( T ) - 1;
M = zeros( no_highpass, 4, 3 );

% TODO: Boundary corrections mess with the length of the signals; only Haar
% works now

squared_coefs = cell( no_highpass, 1 );

for j = no_highpass:-1:1
    squared_coefs{j} = cellfun( @(x) x.^2, T{j+1}, 'uniformoutput', false );
    
    % eta_l^(2)
    M(j, 1, :) = cellfun( @(x) mean(x(:)), squared_coefs{j} );
    
    % eta_l^(4)
    M(j, 2, :) = cellfun( @(x) mean(x(:).^4), T{j+1} );
    
    % eta_l^(2,2)
    [children_combinations{1:3}] = deal(zeros( [size(squared_coefs{j}{1})/2 6] ));
    
    % TODO: Make this work for non-square images
    % TODO: Make this more elegant
    for k = 1:3
        % The children coefficients indexed by Upper/Lower and left/right
        Ul = squared_coefs{j}{k}(1:2:end, 1:2:end);
        Ur = squared_coefs{j}{k}(1:2:end, 2:2:end);
        Ll = squared_coefs{j}{k}(2:2:end, 1:2:end);
        Lr = squared_coefs{j}{k}(2:2:end, 2:2:end);
        
        children_combinations{k}(:, :, 1) = Ul .* Ur;
        children_combinations{k}(:, :, 2) = Ul .* Ll;
        children_combinations{k}(:, :, 3) = Ul .* Lr;
        children_combinations{k}(:, :, 4) = Ur .* Ll;
        children_combinations{k}(:, :, 5) = Ur .* Lr;
        children_combinations{k}(:, :, 6) = Ll .* Lr;
    end
    
    M(j, 3, :) = cellfun( @(x) mean(x(:)), children_combinations );
    
    % xi_l^(2,2)
    if j ~= no_highpass
        parents = cellfun( @(x) kron(x, ones(2)), squared_coefs{j}, 'uniformoutput', false );
        tmp = cellfun( @times, squared_coefs{j+1}, parents, 'uniformoutput', false );
        
        M(j, 4, :) = cellfun( @(x) mean(x(:)), tmp );
    end
end

end
