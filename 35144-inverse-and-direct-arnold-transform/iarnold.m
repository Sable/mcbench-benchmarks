% Inverse Arnold transform, v2, 2012-02-18
% Piotr Sklodowski, <piotr.sk@gmail.com>
%
% @in: two dimensional matrix
% @iter: number of iterations
%
function [ out ] = iarnold( in, iter )
    if (ndims(in) ~= 2)
        error('Oly two dimensions allowed');
    end
    [m n] = size(in);
    if (m ~= n)
        error(['Arnold Transform is defined only for squares. ' ...
        'Please complete empty rows or columns to make the square.']);
    end
    out = zeros(m);
    n = n - 1;
    for j=1:iter
        for y=0:n
            for x=0:n
                p = [ 2 -1 ; -1 1 ] * [ x ; y ];
                out(mod(p(2), m)+1, mod(p(1), m)+1) = in(y+1, x+1);
            end
        end
        in = out;
    end
end
