function varargout = leon(X)
% Leon funcion 
%
%   LEON([x1, x2]) returns the value of the value of the Leon
%   function at the specified points. [x1] and [x2] may be vectors.
%   The search domain is
%
%               -1.2 < x_i < 1.2
%
%   The global minimum is 
%
%               f(x1, x2) = f(1, 1) = 0.

% Author: Rody P.S. Oldenhuis
% Delft University of Technology
% E-mail: oldenhuis@dds.nl
% Last edited 20/Jul/2009

    % if no input is given, return dimensions, bounds and minimum
    if (nargin == 0)
        varargout{1} = 2;  % # dims
        varargout{2} = [-1.2, -1.2]; % LB
        varargout{3} = [+1.2, +1.2]; % UB
        varargout{4} = [1,1]; % solution
        varargout{5} = 0; % function value at solution
        
    % otherwise, output function value
    else
        
        % keep values inside the search domain
        X(X < -1.2) = inf;      X(X > 1.2) = inf;
        
        % split input vector X into x1, x2
        if size(X, 1) == 2
            x1 = X(1, :);        x2 = X(2, :);
        else
            x1 = X(:, 1);        x2 = X(:, 2);
        end
        
        % output function value
        varargout{1} = 100*(x2 - x1.^2).^2 + (1 - x1).^2;
    end
     
end