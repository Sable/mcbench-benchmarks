function T = dwt2_to_cell( C, S )

% Divide wavedec2 output to cell
%
% Syntax:
%   T = dwt_to_cell( C, S )
%
% Input:
%   C : Vector with transform coefficients from wavedec2
%
%   S : Bookkeeping matrix from wavedec2
%
%
% Output:
%   T : C sorted into a cell in the following way:
%       * 1st entry is the low pass part
%       * For l > 1, the l'th entry is the high pass part at level l-1 in
%         three cells: H, V, D

no_levels = size(S, 1) - 1;

% The size of *all* subbands
level_sz = S(1:end-1, :);
subband_sz = kron( level_sz, ones(3,1) );
block_sz = subband_sz(3:end, :);

% The start index of each subband in C
L = cumsum(prod( block_sz, 2 ));

[T{1:no_levels}] = deal( cell(1, 3) );
T{1} = reshape( C(1:L(1)), block_sz(1, 1), block_sz(1, 2) );

for l = 2:no_levels
    for d = 1:3
        sz_idx = 3*(l-2) + d+1;
        
        start_idx = L(sz_idx-1) + 1;
        end_idx = L(sz_idx);
        
        T{l}{d} = reshape( C(start_idx:end_idx), block_sz(sz_idx, 1), block_sz(sz_idx, 2) );
    end
end

end
