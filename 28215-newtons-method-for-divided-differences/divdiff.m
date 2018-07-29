function TDD = divdiff(X, Y)
%
% TDD = divdiff(X, Y)
%
% DIVDIFF
%   Newton's Method for Divided Differences.
%
%   The following formula is solved:
%       Pn(x) = f(x0) + f[x0,x1](x-x0) + f[x0,x1,x2](x-x0)(x-x1) + ...
%           + f[x0,x1,..,xn](x-x0)(x-x1)..(x-x[n-1])
%       where f[x0,x1] = (f(x1-f(x0))/(x1-x0)
%             f[x0,x1,..,xn] = (f[x1,..,xn]-f[x0,..,x_[n-1]])/(xn-x0)
%
% NOTE: f^(n+1)(csi)/(n+1)! aprox. = f[x0,x1,..,xn,x_[n+1]]
%
% Input::
%	X = [ x0 x1 .. xn ] - object vector
%	Y = [ y0 y1 .. yn ] - image vector
%
% Output:
%   TDD - table of divided differences
%
% Example:
%   TDD = divdiff( [ 1.35 1.37 1.40 1.45 ], [ .1303 .1367 .1461 .1614 ])
%
% Author:	Tashi Ravach
% Version:	1.0
% Date:     22/05/2006
%

    if nargin ~= 2
        error('divdiff: invalid input parameters'); 
    end

    [ p, m ] = size(X); % m points, polynomial order <= m-1
    if p ~= 1 || p ~=size(Y, 1) || m ~= size(Y, 2)
        error('divdiff: input vectors must have the same dimension'); 
    end

    TDD = zeros(m, m);
    TDD(:, 1) = Y';
    for j = 2 : m
        for i = 1 : (m - j + 1)
            TDD(i,j) = (TDD(i + 1, j - 1) - TDD(i, j - 1)) / (X(i + j - 1) - X(i));
        end
    end

end