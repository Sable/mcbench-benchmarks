function [ extrap, normtable ] = richardson( A1s, kis, t, exact )
% Perform Richardson extrapolation on approximations A1s.
%
% Input:   A1s       - Row vector of initial approximation data:
%                      A1s(1) = A_{1}(h)
%                      A1s(2) = A_{1}(h/t)
%                      A1s(3) = A_{1}(h/t**2)
%                      ...
%                      A1s can be a matrix, e.g. A1s(:,2) = A_{1}(h/t).
%          kis       - Vector of leading order errors in A1s in terms of h.
%                      Assumed to start at 1 if not specified.  Assumed to
%                      increment by 1 if no second element provided.  If a two
%                      element vector is provided, then any unspecified higher
%                      entries are assumed to grow by kis(end) - kis(end-1).
%          t         - Refinement factor used to step from A1s(i) to A1s(i+1).
%                      Assumed to be 2 if not specified.
%          exact     - Exact solution used to calculate normtable, if requested.
%                      Defaults to zero.
% Output:  extrap    - Richardson extrapolation incorporating all data provided.
%          normtable - Table showing the l2 error of each step in the process
%                      calculated against exact parameter.  With exact equal to
%                      zero, this gives the l2 norm of each Richardson step.
% 
% Written by Rhys Ulerich <rhys.ulerich@gmail.com>
% $Id: richardson.m 803 2009-06-09 19:55:39Z rhys $


% Default argument processing
error(nargchk(1,4,nargin));
if (nargin < 2)
    kis = 1;
end
if (nargin < 3)
    t = 2.0;
end
if (nargin < 4)
    exact = zeros(size(A1s(:,1)));
end

% Sanity check arguments
assert(isnumeric(A1s));
assert(isvector(kis));
assert(all(kis>0));
assert(all(diff(kis)>0));
assert(isscalar(t));
assert(t > 0);
assert(all(size(exact) == size(A1s(:,1))));

% Provide automagic around kis parameter as described in help text
if isscalar(kis)
    kis = [kis, kis+1];
end
while (length(kis) < size(A1s,2))
    kis(end+1) = 2*kis(end) - kis(end-1);
end
assert(length(kis) >= size(A1s,2));

% Create and initialize the normtable if requested
if nargout > 1
    normtable = NaN(size(A1s,2));
    for i = 1:size(A1s,2)
        normtable(i,1) = norm(A1s(:,i) - exact);
    end
end

% Compute the triangular extrapolation table in-place in A1s
for i = 1:(size(A1s,2)-1)
    for j = 1:(size(A1s,2)-i)
        A1s(:,j) = richardson_step( A1s(:,j), A1s(:,j+1), kis(i), t );
        % If requested, compute the associated normtable entry
        if nargout > 1
            normtable(i+j,i+1) = norm(A1s(:,j) - exact);
        end
    end
end

extrap = A1s(:,1);

end %function


function [ Aip1h ] = richardson_step( Aih, Aiht, ki, t)
% Perform Richardson extrapolation on A_{i}(h) and A_{i}(h/t) to get A_{i+1}(h)
%
% Given A(h), an approximation of A such that
% A - A(h) = a_{i}*h^k_{i} + a_{i+1}*h^k_{i+1} + ...
% use Richardson extrapolation to find an approximation to leading order k_{i+1}
% from evaluations at A(h) and A(h/t) for t > 0.  Specifically,
% A_{i+1}(h) = (t**k_{i}*A_{i}(h/t) - A_{i}(h)) / (t**k_{i} - 1).
%
% Input:   Aih   - A_{i}(h)
%          Aiht  - A_{i}(h/t)
%          ki    - k_{i}
%          t     - t
% Output:  Aip1h - A_{i+1}(h)
%
% See http://en.wikipedia.org/wiki/Richardson_extrapolation

tki = t^ki;
Aip1h = (tki*Aiht - Aih) ./ (tki - 1);

end %function

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% UNIT TESTS %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%!test
%! % Default parameter behavior
%! assert(richardson([1, 2]) == richardson([1,2], 1));
%! assert(richardson([1, 2]) == richardson([1,2], 1, 2));
%! assert(richardson([1, 2]) == richardson([1,2], 1, 2, 0));

%!test
%! % Default and non-default values for t
%! assert(abs( richardson([1, 2], 1, 2) - 3.0      ) < 1e-14);
%! assert(abs( richardson([1, 2], 1, 3) - 5.0/2.0  ) < 1e-14);

%!test
%! % Two levels starting with kis(1) = 1
%! assert(abs( richardson([1, 2],        1) - 3.0      ) < 1e-14);
%! assert(abs( richardson([2, 3],        1) - 4.0      ) < 1e-14);
%! assert(abs( richardson([3, 4],        2) - 13.0/3.0 ) < 1e-14);
%! assert(abs( richardson([1, 2, 3],     1) - 13.0/3.0 ) < 1e-14);
%! assert(abs( richardson([1, 2, 3], [1,2]) - 13.0/3.0 ) < 1e-14);

%!test
%! % Two levels starting with kis(1) = 2
%! assert(abs( richardson([1, 2],              2) - 7.0/3.0  ) < 1e-14);
%! assert(abs( richardson([2, 3],              2) - 10.0/3.0 ) < 1e-14);
%! assert(abs( richardson([7.0/3.0, 10.0/3.0], 3) - 73.0/21.0) < 1e-14);
%! assert(abs( richardson([1, 2, 3],           2) - 73.0/21.0) < 1e-14);
%! assert(abs( richardson([1, 2, 3],       [2,3]) - 73.0/21.0) < 1e-14);

%!test
%! % Multiple levels with jumps in order
%! xx = richardson([1, 2], 3);
%! xy = richardson([2, 3], 3);
%! xz = richardson([3, 4], 3);
%! yx = richardson([xx, xy], 6);
%! yy = richardson([xy, xz], 6);
%!
%! % Check one set of leading error terms
%! zx = richardson([yx, yy], 9);
%! assert(abs( richardson([1, 2, 3, 4], [3, 6, 9]) - zx) < 1e-14);
%! assert(abs( richardson([1, 2, 3, 4],    [3, 6]) - zx) < 1e-14);
%!
%! % Check a second set of leading error terms
%! zy = richardson([yx, yy], 8);
%! assert(abs( richardson([1, 2, 3, 4], [3, 6, 8]) - zy) < 1e-14);
%!
%! % Ensure normtable outputs are as expected
%! [ result, normtable ] = richardson([1, 2, 3, 4], [3, 6]);
%! expected              = [ 1, 0,   0,  0; ...
%!                           2, xx,  0,  0; ...
%!                           3, xy, yx,  0; ...
%!                           4, xz, yy, zx];
%! assert(norm(expected-tril(normtable)) < 1e-14);  % Check for results
%! for i = 1:3                                      % Check NaNs correct
%!     for j = (i+1):4
%!         assert(isnan(normtable(i,j)));
%!     end
%! end

%!test
%! % Check vector-valued inputs
%! assert(norm( richardson([1, 2; 2, 3]      ) - [     3.0;      4.0] ) < 1e-14);
%! assert(norm( richardson([1, 2, 3; 2, 3, 4]) - [13.0/3.0; 16.0/3.0] ) < 1e-14);
%!
%! % Check normtable adjusted for vector exact value
%! [ result, normtable ] = richardson([1, 2; 2, 3], 1, 2, [3.0 ; 4.0]);
%! assert(normtable(end,end) == 0.0);
