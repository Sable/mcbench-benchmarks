function [C, S] = cell_to_dwt2( T )

% Divide wavedec2 output to cell
%
% Syntax:
%   [C, S] = cell_to_dwt2( T )
%
%
% Input:
%   T : Cell from dwt2_to_cell.
%
%
% Output:
%   C, S: Output as from WAVEDEC2.

no_levels = numel(T);

S = zeros(no_levels+1, 2);

cur_coef = 0;

for l = 1:no_levels
    % Low pass
    if l == 1
        % Size matrix
        S(1,:) = size(T{1});
        N = numel(T{1});
        
        % Fill coefficients
        C(cur_coef + (1:N)) = T{1}(:);
        
        cur_coef = cur_coef + N;
        continue
    end
    
    % High pass
    for d = 1:3
        % Size matrix
        S(l,:) = size(T{l}{1});
        N = prod( S(l,:) );
        
        % Fill coefficients
        C(cur_coef + (1:N)) = T{l}{d}(:);
        
        cur_coef = cur_coef + N;
        
    end
end

% Size of image
% TODO: This is not a robust way!
S(no_levels+1, :) = 2 * S(no_levels, :);

end
