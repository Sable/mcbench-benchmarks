function varargout = wood(X)
% Wood function
%
%   WOOD([x1, x2, x3, x4]) returns the value of the Wood 
%   function at the specified points. [x1] through [x4] may be vectors. 
%
%   The global minimum is 
%
%               f(x1, x2, x3, x4) = f(1, 1, 1, 1) = 0

% Author: Rody P.S. Oldenhuis
% Delft University of Technology
% E-mail: oldenhuis@dds.nl
% Last edited 20/Jul/2009

    % if no input is given, return dimensions, bounds and minimum
    if (nargin == 0)
        varargout{1} = 4;        % # dims
        varargout{2} = [-inf, -inf, -inf, -inf]; % LB
        varargout{3} = [+inf, +inf, +inf, +inf]; % LB
        varargout{4} = [1, 1, 1, 1]; % solution
        varargout{5} = 0; % function value at solution

    % otherwise, output function value
    else

        % split input vector X into x1, x2, x3, x4
        if size(X, 1) == 4
            x1 = X(1, :);        x2 = X(2, :);
            x3 = X(3, :);        x4 = X(4, :);
        else
            x1 = X(:, 1);        x2 = X(:, 2);
            x3 = X(:, 3);        x4 = X(:, 4);
        end

        % output function value
        varargout{1} = 100*(x1.^2 - x2).^2 + (x1 - 1).^2 + (x3 - 1).^2 + 90*(x3.^2 - x4).^2 + ...
            10.1*((x2 - 1).^2 + (x4 - 1).^2)  + 19.8*(x2 - 1).*(x4 - 1);
    end
     
end
