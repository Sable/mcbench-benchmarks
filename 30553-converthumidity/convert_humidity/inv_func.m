% y = f(x)
% x = f_inv(y)
function [x, y2, tolx, toly] = inv_func (f, y, x_approx, tolx)
    if (nargin < 4) || isempty(tolx),  tolx = eps;  end
    opt = optimset('TolX', tolx);

    discr = @(x) f(x) - y;
    [x, temp] = fzero(discr, x_approx, opt);
    y2 = y + temp;
    %TODO: support vector x,y; iterate over each element.

    if (nargout < 4),  return;  end
    dy_dx = diff_func(f, x);
    toly = sqrt(dy_dx .* tolx.^2 .* dy_dx);
end

%!test
%! f = @(x) 1./x;
%! x = 0.5;
%! y = f(x);
%! x_approx = 0.3;
%! [x2, y2, tolx, toly] = inv_func(f, y, x_approx);
%! myassert(x2, x, -tolx);

%!test
%! f = @(x) cos(x);
%! x = randint(0, pi);
%! y = f(x);
%! [x2, y2, tolx, toly] = inv_func(f, y, [0, pi]);
%! x3 = acos(y);
%! myassert(x2, x, -tolx);
%! myassert(x3, x, -tolx);
