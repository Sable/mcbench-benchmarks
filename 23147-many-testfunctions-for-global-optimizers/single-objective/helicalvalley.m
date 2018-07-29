function varargout = helicalvalley(X)
% Helical valley function
%
%   HELICALVALLEY([x1, x2, x3]) returns the value of the value of the 
%   Helical valley function at the specified points. All [xi] may be 
%   vectors. 
%
%   The global minimum is
%
%                   f(x1, x2, x3) = f(1, 0, 0) = 0.

% Author: Rody P.S. Oldenhuis
% Delft University of Technology
% E-mail: oldenhuis@dds.nl
% Last edited 20/Jul/2009

    % if no input is given, return dimensions, bounds and minimum
    if (nargin == 0)
        varargout{1} = 3;  % # dims
        varargout{2} = [-inf, -inf, -inf]; % LB
        varargout{3} = [+inf, +inf, +inf]; % UB
        varargout{4} = [1, 0, 0]; % solution
        varargout{5} = 0; % function value at solution
        
    % otherwise, output function value
    else
        
        % split input vector X into x1, x2, x3
        if size(X, 1) == 3
            x1 = X(1, :);  x2 = X(2, :);  x3 = X(3, :);
        else
            x1 = X(:, 1);  x2 = X(:, 2);  x3 = X(:, 3);
        end
        
        % output function value
        varargout{1} = 100*((x3 - 10*atan2(x2, x1)/2/pi).^2 + (sqrt(x1.^2 + x2.^2) - 1).^2) + x3.^2;
    
    end
     
end