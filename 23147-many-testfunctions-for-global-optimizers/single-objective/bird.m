function varargout = bird(X)
% Bird function
%
%   BIRD([x1, x2]) returns the value of the Bird function 
%   at the specified points. [x1] and [x2] may be vectors. 
%   The search domain is
%
%               -2pi < x_i < 2pi
%
%   The two global minima are
%
%                   fmin = -106.764537

% Author: Rody P.S. Oldenhuis
% Delft University of Technology
% E-mail: oldenhuis@dds.nl
% Last edited 20/Jul/2009

    % if no input is given, return dimensions, bounds and minimum
    if (nargin == 0)
        varargout{1} = 2;  % # dims
        varargout{2} = [-inf, -inf]; % LB
        varargout{3} = [+inf, +inf]; % UB
        varargout{4} = [4.701055751981055e+000, +3.152946019601391e+000
                       -1.582142172055011e+000  -3.130246799635430e+000]; % solution
        varargout{5} = -1.067645367198034e+002; % function value at solution

    % otherwise, output function value
    else
        
        % keep values in the search interval
        X(X < -2*pi) = inf;     X(X > 2*pi) = inf;
        
        % split input vector X into x1, x2
        if size(X, 1) == 2
            x1 = X(1, :);        x2 = X(2, :);
        else
            x1 = X(:, 1);        x2 = X(:, 2);
        end
        
        % output function value
        varargout{1} = sin(x1).*exp((1-cos(x2)).^2) + cos(x2).*exp((1-sin(x1)).^2) + (x1-x2).^2;
        
    end
     
end