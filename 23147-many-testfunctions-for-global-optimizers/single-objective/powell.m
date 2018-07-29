function varargout = powell(X)
% Powell's singular function
%
%   POWELL([x1, x2, x3, x4]) returns the value of the Powell singular 
%   function at the specified points. All [xi] may be vectors.
%
%   The global minimum is 
%
%               f(x1, x2, x3, x4) = f(0, 0, 0, 0) = 0.

% Author: Rody P.S. Oldenhuis
% Delft University of Technology
% E-mail: oldenhuis@dds.nl
% Last edited 20/Jul/2009

    % if no input is given, return dimensions, bounds and minimum
    if (nargin == 0)
        varargout{1} = 4;  % # dims
        varargout{2} = [-inf, -inf, -inf, -inf]; % LB
        varargout{3} = [+inf, +inf, +inf, +inf]; % UB
        varargout{4} = [0, 0, 0, 0]; % solution
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
        varargout{1} = (x1 + 10*x2).^2 + 5*(x3 - x4).^2 + (x2 - 2*x3).^4 + 10*(x1 - x4).^4;
    end
         
end