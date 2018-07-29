function varargout = zettl(X)
% Zettl function
%
%   ZETTL([x1, x2]) returns the value of the Zettle function at the
%   specified points. [x1] and [x2] may be vectors. The search domain 
%   is 
%
%               -5 < x_i < 5
%
%   The global minimum is 
%
%               f(x1, x2) = f(-0.0299, 0) = -0.003791

% Author: Rody P.S. Oldenhuis
% Delft University of Technology
% E-mail: oldenhuis@dds.nl
% Last edited 20/Jul/2009

    % if no input is given, return dimensions, bounds and minimum
    if (nargin == 0)
        varargout{1} = 2;        % # dims
        varargout{2} = [-5, -5]; % LB
        varargout{3} = [+5, +5]; % UB
        varargout{4} = [-2.989597760285287e-002, 0]; % solution
        varargout{5} = -3.791237220468656e-003; % function value at solution
        
    % otherwise, output function value
    else
        % keep all values in the search domain
        X(X < -5) = inf;        X(X > 5) = inf;
        
        % split input vector X into x1, x2
        if size(X, 1) == 2
            x1 = X(1, :);        x2 = X(2, :);
        else
            x1 = X(:, 1);        x2 = X(:, 2);
        end
        
        % output function value
        varargout{1} = (x1.^2 + x2.^2 - 2*x1).^2 + x1/4;
    end
    
end