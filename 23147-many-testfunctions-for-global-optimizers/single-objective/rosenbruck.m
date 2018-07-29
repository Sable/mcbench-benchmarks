function varargout = rosenbruck(X)
% Extended Rosenbruck's Banana-function, for N-dimensional input
%
%   ROSENBRUCK([x1, x2, .., xn]) returns the value of the Rosenbruck
%   function at the specified points. All [xi] may be vectors. The search 
%   domain is
%
%               -100 < x_i < 100
%
%   The global minimum is 
%
%               f(x1, x2, ..., xn) = f(1, 1, ..., 1) = 0

% Author: Rody P.S. Oldenhuis
% Delft University of Technology
% E-mail: oldenhuis@dds.nl
% Last edited 28/Feb/2009

    % if no input is given, return dimensions, bounds and minimum
    if (nargin == 0)
        varargout{1} = inf;  % # dims
        varargout{2} = -100; % LB
        varargout{3} = +100; % UB
        varargout{4} = 1; % solution
        varargout{5} = 0; % function value at solution
        
    % otherwise, output function value
    else
        
        % keep all values within the domain
        X(X < -100) = inf;  X(X > 100) = inf;
        
        % split input vector X into X1, X2
        % NOTE: proper orientation can not be determined automatically
        % the sum is taken by default over the rows:
        X1 = X(1:2:end-1, :);        X2 = X(2:2:end, :);
        
        % output rowsum
        varargout{1} = sum(  100*(X2 - X1.^2).^2 + (1 - X1).^2, 1);
    end
    
end