function [x, y2] = inv_func2 (f, y, x_approx, tolx)
    if (nargin < 4),  tolx = [];  end
    n = length(x_approx);
    myassert(length(y) == n);
    
    x = zeros(size(x_approx));
    y2 = zeros(size(y));
    for i=1:n
        [x(i), y2(i)] = inv_func (f, y(i), x_approx(i), tolx);
    end
end
