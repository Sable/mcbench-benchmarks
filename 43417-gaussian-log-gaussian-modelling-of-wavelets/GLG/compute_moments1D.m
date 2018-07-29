function M = compute_moments1D( T )

% Compute moments of noise free wavelet coefficients
% The moments used for parameter estimation in the GLG model are computed.
%
% Syntax:
%   M = compute_moments1D( T )
%
% Input:
%   T : Cell from DWT2_TO_CELL.
%
% Output:
%   M : L-by-4 matrix where L is the number of levels in the wavelet
%       transform and the (l+1)'th row is
%       eta_l^(2), eta_l^(4), eta_l^(2,2), xi_l^(2,2)

% Allocate output
no_highpass = length( T ) - 1;
M = zeros( no_highpass, 4 );

% TODO: Boundary corrections mess with the length of the signals; only Haar
% works now

squared_coefs = cell( no_highpass, 1 );

for j = no_highpass:-1:1
    squared_coefs{j} = T{j+1}{1}.^2;
    
    % eta_l^(2)
    M(j, 1) = mean( squared_coefs{j} );
    
    % eta_l^(4)
    M(j, 2) = mean( T{j+1}{1}.^4 );
    
    % eta_l^(2,2)
    M(j, 3) = mean( squared_coefs{j}(1:2:end) .* squared_coefs{j}(2:2:end) );
    
    % xi_l^(2,2)
    if j ~= no_highpass
        tmp = zeros( size(squared_coefs{j+1}) );
        tmp(1:2:end) = squared_coefs{j};
        tmp(2:2:end) = squared_coefs{j};
        
        M(j, 4) = mean( tmp .* squared_coefs{j+1} );
    end
end

end
