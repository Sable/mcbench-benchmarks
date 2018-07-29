function varargout = trigonometric(X)
% Trigonometric function
%
%   TRIGONOMETRIC([x1, x2, ..., xn]) returns the value of the 
%   trigonometric fnuction at the specified points. All [xi] may be
%   vectors. 
%
%   The global minimum is 
%
%               f(x1, x2, ..., xn) = f(0, 0, ..., 0) = 0.

% Author: Rody P.S. Oldenhuis
% Delft University of Technology
% E-mail: oldenhuis@dds.nl
% Last edited 28/Feb/2009

    % if no input is given, return dimensions, bounds and minimum
    if (nargin == 0)
        varargout{1} = inf;  % # dims
        varargout{2} = -inf; % LB
        varargout{3} = +inf; % LB
        varargout{4} = 0; % solution
        varargout{5} = 0; % function value at solution

    % otherwise, output function value
    else

        % create basevectors
        n = size(X, 2);
        i = repmat(1:n, size(X, 1), 1);

        % compute cosine only once
        cosX = cos(X);

        % compute intermediate sum
        sumcosX = repmat(sum(cosX, 2), 1, n);

        % output rowsum
        varargout{1} = sum( (n + i.*(1 - cosX) - sin(X) - sumcosX).^2, 2);

    end
     
end
