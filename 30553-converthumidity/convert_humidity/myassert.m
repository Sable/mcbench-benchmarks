function myassert (observed, expected, tol)
    if (nargin == 1)
        if observed  % is true
            return; 
        end
    elseif (nargin == 2)
        if isempty(observed) && isempty(expected), return; end
        if isequalwithequalnans (observed, expected), return; end
    elseif (nargin == 3)
        if (...
               issparse(observed) ...
            || issparse(expected) ...
            || issparse(tol) ) ...
           && ( ...
               isa(observed, 'single') ...
            || isa(expected, 'single') ...
            || isa(     tol, 'single') )
            observed = double(observed);
            expected = double(expected);
            tol      = double(tol);
        end
        if isempty(observed) && isempty(expected), return; end
        if ~isequal(size(observed), size(expected)) ...
           && ~isscalar(observed) && ~isscalar(expected)
            %
        elseif (tol < 0)
            if all(  ( abs(observed - expected) <= abs(tol) ) ...
                   | ( isnan(observed) & isnan(expected) ) )
                return; 
            end
        else
            temp = abs(observed - expected) ...
                   <= (abs(expected)*tol + eps(class(expected)));
            if all(temp(:))
                return; 
            end
        end
    end

    s.identifier = 'myassert:error';
    s.message = 'Assert error.';
    s.stack = dbstack;
    if length(s.stack) > 1, s.stack(1) = [];  end
    error(s);
end

%!test
%! a = [0 0 eps eps NaN];
%! b = [0 0 0 0 NaN];
%! myassert (a, b, -eps);

%!test
%! myassert (1);
%! myassert (1, 1);
%! myassert (5, 5);
%! myassert (5, 4, 1);
%! myassert (500, 550, 1.1);
%! myassert (500, 550, -50);

%!test
%! % test vector arguments:
%! myassert ([1 1 1], [1 1 1]);
%! myassert ([500 500], [550 550], 1.1);
%! myassert ([500 500], [550 550], -50);

%!error
%! myassert ([500 500], [550 551], -50);

%!test
%! myassert ([1 NaN 1], [1 NaN 1]);

%!test
%! myassert ([1 NaN 1], [1+eps NaN 1+eps], -eps);

%!error
%! myassert (false);

%!test
%! myassert (zeros(0,1), zeros(0,0));
%! myassert (zeros(0,1), zeros(0,0), -eps);

%!error
%! lasterr ('', '');
%! myassert (zeros(2,1), zeros(3,1), -eps)

%!test
%! % myassert ()
%! s = lasterror;
%! myassert (s.identifier, 'myassert:error');

%!test
%! myassert (strcmp('badSize', 'badSize'));

%!test
%! myassert ([1 1], 1, 0)

%!error
%! myassert([1 1], 1)

%!test
%! myassert ([2.2 1.8], 2, 0.1)

%!test
%! myassert ([-2.2 -1.8], -2, 0.1)

%!error
%! myassert ([2.2 1.8; 2, 0], 2, 0.1)

%!test
%! myassert(sparse(1), single(1), 0)

%!test
%! myassert(sparse(1), double(1), single(0))
