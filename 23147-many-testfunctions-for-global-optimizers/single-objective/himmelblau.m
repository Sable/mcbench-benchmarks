function varargout = himmelblau(X)
% Himmelblau function
%
%   HIMMELBLAU([x1, x2]) returns the value of the value of the 
%   Himmelblau function at the specified points. [x1] and [x2] may 
%   be vectors. The search domain is
%
%               -5 < x_i < 5
%
%   The four global minima are 
%
%   f(x, y) = f( 3.000000000000000,  2.000000000000000) = 0
%	f(x, y) = f(-3.779310253377747, -3.283185991286170) = 0
%	f(x, y) = f(-2.805118086952745,  3.131312518250573) = 0
%   f(x, y) = f( 3.584428340330492, -1.848126526964404) = 0

% Author: Rody P.S. Oldenhuis
% Delft University of Technology
% E-mail: oldenhuis@dds.nl
% Last edited 20/Jul/2009

    % if no input is given, return dimensions, bounds and minimum
    if (nargin == 0)
        varargout{1} = 2;  % # dims
        varargout{2} = [-5, -5]; % LB
        varargout{3} = [+5, +5]; % UB
        varargout{4} = [+3.000000000000000, +2.000000000000000
                        -3.779310253377747, -3.283185991286170
                        -2.805118086952745, +3.131312518250573
                        +3.584428340330492, -1.848126526964404]; % solution
        varargout{5} = 0; % function value at solution
        
    % otherwise, output function value
    else
        
        % keep values in the search domain
        X(X < -5) = inf;    X(X > 5) = inf;
        
        % split input vector X into x1, x2
        if size(X, 1) == 2
            x1 = X(1, :);        x2 = X(2, :);
        else
            x1 = X(:, 1);        x2 = X(:, 2);
        end
        
        % function output
        varargout{1} = (x1.^2 + x2 - 11).^2 + (x1 + x2.^2 - 7).^2;
        
    end

end