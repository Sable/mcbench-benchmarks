function T = dwt_to_cell( C, L )

% Divide wavedec output to cell
%
% Syntax:
%   T = dwt_to_cell( C, L )
%
% Input:
%   C : Vector with transform coefficients from wavedec
%
%   L : Bookkeeping vector from wavedec
%
%
% Output:
%   T : C sorted into a cell in the following way:
%       * 1st entry is the low pass part
%       * For l > 1, the l'th entry is the high pass part at level l-1

no_levels = numel(L) - 1;
L = cumsum( L );

[T{1:no_levels}] = deal( cell(1) );
T{1} = C( 1:L(1) );

for l = 2:no_levels
    start_idx = L(l-1) + 1;
    end_idx = L(l);
    
    T{l}{1} = C( start_idx:end_idx );
end

end
