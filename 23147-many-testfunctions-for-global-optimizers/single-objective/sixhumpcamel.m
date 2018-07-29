function varargout = sixhumpcamel(X)
% six hump camel back function 
%
%   SIXHUMPCAMEL([x1, x2]) returns the value of the Six Hump Camel Back 
%   function at the specified points. [x1] and [x2] may be vectors. The 
%   search domain is 
%
%               -5 < x_i < 5
%
%   The two global minima are 
%
%               f(x1, x2) = f(+-0.088942..., -+0.721656...) = -1.031628....

% Author: Rody P.S. Oldenhuis
% Delft University of Technology
% E-mail: oldenhuis@dds.nl
% Last edited 20/Jul/2009

    % if no input is given, return dimensions, bounds and minimum
    if (nargin == 0)
        varargout{1} = 2;  % # dims
        varargout{2} = [-5, -5]; % LB
        varargout{3} = [+5, +5]; % UB
        varargout{4} = [+8.984201368301331e-002    -7.126564032704135e-001
                        -8.984201368301331e-002    +7.126564032704135e-001]; % solution
        varargout{5} = -1.031628453489877e+000; % function value at solution

    % otherwise, output function value
    else
        
        % keep all values in the search domain
        X(X < -5) = inf;        X(X > 5) = inf;
        
        % split input vector X into x1, x2
        if size(X, 1) == 2
            x1 = X(1, :);        x2 = X(2, :);
        else
            x1 = X(:, 1);        x2 = X(:, 2);
        end
        
        % output function value
        varargout{1} = (4 - 2.1*x1.^2 + x1.^4/3).*x1.^2 + x1.*x2 + (4*x2.^2 - 4).*x2.^2;
        
    end
     
end
