function varargout = holdertable(X)
% Holder table function
%
%   HOLDERTABLE([x1, x2]) returns the value of the Holder table
%   function at the specified points. [x1] and [x2] may be vectors.
%   The search domain is
%
%               -10 < x_i < 10
%
%   The four global minima are near the edges of the interval, and have a
%   function value of 
%
%       f(x*) = -1.92085026. 

% Author: Rody P.S. Oldenhuis
% Delft University of Technology
% E-mail: oldenhuis@dds.nl
% Last edited 20/Jul/2009

    % if no input is given, return dimensions, bounds and minimum
    if (nargin == 0)
        varargout{1} = 2;  % # dims
        varargout{2} = [-10, -10]; % LB
        varargout{3} = [+10, +10]; % UB
        varargout{4} = [+8.055023472141116e+000   +9.664590028909654e+000
                        -8.055023472141116e+000   +9.664590028909654e+000
                        +8.055023472141116e+000   -9.664590028909654e+000
                        -8.055023472141116e+000   -9.664590028909654e+000]; % solution
        varargout{5} = -1.920850256788675e+001; % function value at solution
        
    % otherwise, output function value
    else
        
        % keep values within the search interval
        X(X < -10) = inf;      X(X > 10) = inf;
        
        % split input vector X into x1, x2
        if size(X, 1) == 2
            x1 = X(1, :);        x2 = X(2, :);
        else
            x1 = X(:, 1);        x2 = X(:, 2);
        end
        
        % output function value
        varargout{1} = -abs(sin(x1).*cos(x2).*exp(abs(1 - sqrt(x1.^2 + x2.^2)/pi)));
        
    end
     
end