function varargout = bukin2(X)
% Bukin function #2
%
%   BUKIN2([x1, x2]) returns the value of the 2nd Bukin function
%   at the specified points. [x1] and [x2] may be vectors. 
%   The search domain is
%
%               -15 < x_1 < -5
%                -3 < x_2 <  3
%
%   The global minimum is 
%
%               f(x1, x2) = f(-10, 0) = 0

% Author: Rody P.S. Oldenhuis
% Delft University of Technology
% E-mail: oldenhuis@dds.nl
% Last edited 20/Jul/2009

    % if no input is given, return dimensions, bounds and minimum
    if (nargin == 0)
        varargout{1} = 2;  % # dims
        varargout{2} = [-15, -3]; % LB
        varargout{3} = [-5,  +3]; % UB
        varargout{4} = [-10, 0]; % solution
        varargout{5} = 0; % function value at solution

    % otherwise, output function value
    else
        
        % split input vector X into x1, x2
        if size(X, 1) == 2
            x1 = X(1, :);        x2 = X(2, :);
        else
            x1 = X(:, 1);        x2 = X(:, 2);
        end
        
        % keep values in the serach interval
        x1(x1 < -15) = inf;     x1(x1 > -5) = inf;
        x2(x2 <  -3) = inf;     x2(x2 >  3) = inf;
        
        % output function value
        varargout{1} = 100*(x2 - 0.01*x1.^2 + 1) + 0.01*(x1 + 10).^2;
    
    end
     
end