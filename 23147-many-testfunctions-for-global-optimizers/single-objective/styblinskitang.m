function varargout = styblinskitang(X)
% Styblinski-Tang function
%
%   STYBLINSKYTANG([x1, x2, ..., xn]) returns the value of the 
%   Styblinski-Tang at the specified points. All [xi] may be vectors. 
%   The search domain is 
%
%               -5 < x_i < 5
%
%   The global minimum is 
%
%               f(x1, x2, ..., xn) = 
%               f(-2.903534, -2.903534, ..., -2.903534) = -39.16599 * n

% Author: Rody P.S. Oldenhuis
% Delft University of Technology
% E-mail: oldenhuis@dds.nl
% Last edited 20/Jul/2009

    % if no input is given, return dimensions, bounds and minimum
    if (nargin == 0)
        varargout{1} = inf;  % # dims
        varargout{2} = -5; % LB
        varargout{3} = +5; % LB
        varargout{4} = -2.903534018185960e+000; % solution
        varargout{5} = -3.916616570377142e+001; % *(#dims) .. function value at solution

    % otherwise, output function value
    else

        % keep all values in the search domain
        X(X < -5) = inf;  X(X > 5) = inf;

        % NOTE: orientation can not be determined automatically
        % defaults to columnsums...
        varargout{1} = sum(X.^4 - 16*X.^2 + 5*X, 1)/2;

    end
   
end