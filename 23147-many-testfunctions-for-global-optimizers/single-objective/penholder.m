function varargout = penholder(X)
% Pen holder function
%
%   PENHOLDER([x1, x2]) returns the value of the Pen holder
%   function at the specified points. [x1] and [x2] may be vectors.
%   The search domain is
%
%               -11 < x_i < 11
%
%   The global minimum is 
%
%               f(x1, x2) = f(-9.64617, 9.64617) = -0.96353.

% Author: Rody P.S. Oldenhuis
% Delft University of Technology
% E-mail: oldenhuis@dds.nl
% Last edited 20/Jul/2009

    % if no input is given, return dimensions, bounds and minimum
    if (nargin == 0)
        varargout{1} = 2;  % # dims
        varargout{2} = [-11, -11]; % LB
        varargout{3} = [+11, +11]; % UB
        varargout{4} = [-9.646167708023526e+000, 9.646167671043401e+000]; % solution
        varargout{5} = -9.635348327265058e-001; % function value at solution
        
    % otherwise, output function value
    else 
        
        % keep all values in the search domain
        X(X < -11) = inf;      X(X > 11) = inf;
        
        % split input vector X into x1, x2
        if size(X, 1) == 2
            x1 = X(1, :);        x2 = X(2, :);
        else
            x1 = X(:, 1);        x2 = X(:, 2);
        end
        
        % output function value
        varargout{1} = -exp(-(abs(cos(x1).*cos(x2).*exp(abs(1 - sqrt(x1.^2 + x2.^2)/pi)))).^(-1));
        
    end
     
end