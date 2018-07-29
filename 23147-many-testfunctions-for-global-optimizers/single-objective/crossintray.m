function varargout = crossintray(X)
% Cross-in-tray function
%
%   CROSSINTRAY([x1, x2]) returns the value of thecross-in-tray 
%   function at the specified points. [x1] and [x2] may be vectors. 
%   The search domain is
%
%               -10 < x_i < 10
%
%   The global minimum is found on the planes x = 0 and y = 0, with
%
%                   f(x1, x2) = f(1.34951, -1.34951) = -2.062612.

% Author: Rody P.S. Oldenhuis
% Delft University of Technology
% E-mail: oldenhuis@dds.nl
% Last edited 20/Jul/2009

    % if no input is given, return dimensions, bounds and minimum
    if (nargin == 0)
        varargout{1} = 2;  % # dims
        varargout{2} = [-10, -10]; % LB
        varargout{3} = [+10, +10]; % UB
        varargout{4} = [+1.349406685353340e+000   +1.349406608602084e+000
                        -1.349406685353340e+000   +1.349406608602084e+000
                        +1.349406685353340e+000   -1.349406608602084e+000
                        -1.349406685353340e+000   -1.349406608602084e+000]; % solution 
        varargout{5} = -2.062611870822739e+000; % function value at solution

    % otherwise, output function value
    else
        
        % keep values in the serach interval
        X(X < -10) = inf;     X(X > 10) = inf;
        
        % split input vector X into x1, x2
        if size(X, 1) == 2
            x1 = X(1, :);        x2 = X(2, :);
        else
            x1 = X(:, 1);        x2 = X(:, 2);
        end
        
        % output function value
        varargout{1} = -0.0001*(abs(sin(x1).*sin(x2).*exp(abs(100 - sqrt(x1.^2 + x2.^2)/pi))) + 1).^(0.1);
        
    end
     
end