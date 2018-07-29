function answer = randint (lower, upper, varargin)
    if (lower > upper)
        error('MATLAB:randint:wrongInput', ...
        'First argument must be smaller than second.');
    end
    if (nargin < 3),  varargin = {1};  end  % give no size, get scalar.
    answer = lower + rand(varargin{:}).*(upper - lower);
end

%!shared
%! n = ceil(10*rand);
%! m = ceil(10*rand);
%! t = rand(2,1);
%! l = min(t);
%! u = max(t);

%!test
%! rand('seed', 0);
%! a = rand(n, m);
%! rand('seed', 0);
%! a2 = randint(0, 1, n, m);
%! %a2, a
%! myassert(a2, a)

%!test
%! rand('seed', now);
%! a = randint(l, u, n, m);
%! %t = a - l; t(a < l)
%! myassert(l <= a | abs(l-a) < eps)
%! myassert(u >= a | abs(u-a) < eps)

%!test
%! % randint
%! lasterror('reset')

%!error
%! randint(1,0)

%!test
%! % randint
%! s = lasterror;
%! myassert(strcmp(s.identifier, 'MATLAB:randint:wrongInput'))

%!test
%! % give no size, get scalar:
%! myassert(isscalar(randint(0, 1)))

