function varargout = crosslegtable(X)
% Cross-leg table function
%
%   CROSSLEGTABLE([x1, x2]) returns the value of the Cross-legged 
%   table function at the specified points. [x1] and [x2] may be vectors.
%   The search domain is
%
%               -10 < x_i < 10
%
%   The global minimum is found on the planes x = 0 and y = 0, with
%
%                   fmin = -1.

% Author: Rody P.S. Oldenhuis
% Delft University of Technology
% E-mail: oldenhuis@dds.nl
% Last edited 20/Jul/2009

    % if no input is given, return dimensions, bounds and minimum
    if (nargin == 0)
        varargout{1} = 2;  % # dims
        varargout{2} = [-10, -10]; % LB
        varargout{3} = [+10, +10]; % UB
        varargout{4} = NaN; % solution (too complicated)
        varargout{5} = -1; % function value at solution

    % otherwise, output function value
    else

        % keep values in the serach interval
        X(X < -10) = inf;     X(X > 10) = inf;

        % split input vector X into x1, x2
        if size(X, 1) == 2
            x1 = X(1, :);        x2 = X(2, :);
        else
            x1 = X(:, 1);        x2 = X(:, 2);
        end

        % output function value
        varargout{1} = -(abs(sin(x1).*sin(x2).*exp(abs(100 - sqrt(x1.^2 + x2.^2)/pi))) + 1).^(-0.1);

    end
     
end