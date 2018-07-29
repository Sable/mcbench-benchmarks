function varargout = goldsteinprice(X)
% Goldstein-Price function
%
%   GOLDSTEINPRICE([x1, x2]) returns the value of the value of the 
%   Goldstein-Price function at the specified points. [x1] and [x2] 
%   may be vectors. The search domain is
%
%               -2 < x_i < 2
%
%   The golbal minimum is
%
%               f(x1, x2) = f(0, -1) = 3.
    
% Author: Rody P.S. Oldenhuis
% Delft University of Technology
% E-mail: oldenhuis@dds.nl
% Last edited 20/Jul/2009

    % if no input is given, return dimensions, bounds and minimum
    if (nargin == 0)
        varargout{1} = 2;  % # dims
        varargout{2} = [-2, -2]; % LB
        varargout{3} = [+2, +2]; % UB
        varargout{4} = [0, -1]; % solution
        varargout{5} = 3; % function value at solution
        
    % otherwise, output function value
    else

        % keep values in the search domain
        X(X < -2) = inf;  X(X > 2) = inf;
        
        % split input vector X into x1, x2
        if size(X, 1) == 2
            x1 = X(1, :);        x2 = X(2, :);
        else
            x1 = X(:, 1);        x2 = X(:, 2);
        end
        
        % output function value
        varargout{1} = (1  + (x1 + x2 + 1).^2.*(19 - 14*x1 +  3*x1.^2 - 14*x2 +  6*x1.*x2 +  3*x2.^2)).*...
            (30 + (2*x1 - 3*x2).^2.*(18 - 32*x1 + 12*x1.^2 + 48*x2 - 36*x1.*x2 + 27*x2.^2));
        
    end
     
end