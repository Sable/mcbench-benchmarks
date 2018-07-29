function varargout = levi13(X)
% Levi function, #13
%
%   LEVI13([x1, x2]) returns the value of the value of the 13th Levi
%   function at the specified points. [x1] and [x2] may be vectors.
%   The search domain is
%
%               -10 < x_i < 10
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
        varargout{2} = [-10, -10]; % LB
        varargout{3} = [+10, +10]; % UB
        varargout{4} = [1,1]; % solution
        varargout{5} = 0; % function value at solution
        
    % otherwise, output function value
    else
        
        % keep values in teh search domain
        X(X < -10) = inf;       X(X > 10) = inf;
        
        % split input vector X into x1, x2
        if size(X, 1) == 2
            x1 = X(1, :);        x2 = X(2, :);
        else
            x1 = X(:, 1);        x2 = X(:, 2);
        end
        
        % output function value
        varargout{1} = sin(3*pi*x1).^2 + (x1-1).^2.*(1 + sin(3*pi*x2).^2) + ...
            (x2-1).^2.*(1 + sin(2*pi*x2).^2);
        
    end
     
end