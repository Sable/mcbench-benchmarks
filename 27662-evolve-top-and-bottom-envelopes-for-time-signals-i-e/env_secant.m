function [env] = env_secant(x_data, y_data, view, side) 
% Function call: env_secant(x_data, y_data, view, side) 
% Calculates the top envelope of data <y_data> over <x_data>.
% Method used: 'secant-method'
% env_secant() observates the max. slope of about <view> points,
% and joints them to the resulting envelope.
% An interpolation over original x-values is done finally.
% <side> ('top' or 'bottom') defines which side to evolve.
% Author: Andreas Martin, Volkswagen AG, Germany


side = strcmpi( {'top','bottom'}, side ) * [ 1 ; -1 ];

assert( view > 1, ...
       'Parameter <view> too small!' );
assert( ndims (x_data) == 2, ...
       'Parameter <x_data> has to be vector type!' );
assert( size (x_data, 1) == 1 || size (x_data, 2) == 1, ...
       'Parameter <x_data> has to be vector type (Nx1)!' );
assert( ndims (y_data) == 2, ...
       'Parameter <y_data> has to be vector type (Nx1)!' );
assert( size (y_data, 1) == 1 || size (y_data, 2) == 1, ...
       'Parameter <y_data> has to be vector type (Nx1)!' );
assert( length (x_data) == length (y_data), ...
       'Parameters <x_data> and <y_data> must have same length!' );
assert( side ~= 0, ...
       'Parameter <side> must be ''top'' or ''bottom''' );

y_data = y_data(:);
data_len = length( y_data );
x_new = [];
y_new = [];

i = 1;
while i < data_len;
    ii = i+1:min( i + view, data_len );
    [ m, idx ] = max( ( y_data(ii) - y_data(i) ) ./ (ii-i)' .* side );

    % Equidistant x_data assumed! Use next row instead, if not:
    %[ m, idx ] = max( ( y_data(ii) - y_data(i) ) ./ ( x_data(ii) - x_data(i) ) * side );
    
    % New max. slope: store new "observation point"
    i = i + idx;
    x_new = [ x_new x_data(i) ];
    y_new = [ y_new y_data(i) ];
end;

env = interp1( x_new, y_new, x_data, 'linear', 'extrap' );
