function varargout = giunta(X)
% Giunta function
%
%   GIUNTA([x1, x2]) returns the value of the value of the Giunta 
%	function at the specified points. [x1] and [x2] may be vectors. 
%   The search domain is
%
%               -1 < x_i < 1
%
%   The golbal minimum is
%
%               f(x1, x2) = f(0.45834282, 0.45834282) = 0.0602472184.
    
% Author: Rody P.S. Oldenhuis
% Delft University of Technology
% E-mail: oldenhuis@dds.nl
% Last edited 20/Jul/2009

    % if no input is given, return dimensions, bounds and minimum
    if (nargin == 0)
        varargout{1} = 2;  % # dims
        varargout{2} = [-1, -1]; % LB
        varargout{3} = [+1, +1]; % UB
        varargout{4} = [4.673200277395354e-001  4.673200169591304e-001]; % solution
        varargout{5} = 6.447042053690566e-002; % function value at solution
        
    % otherwise, output function value
    else
        
        % keep values in the search domain
        X(X < -1) = inf;  X(X > 1) = inf;
        
        % compute sine argument
        arg = 16*X/15 - 1;
        
        % split input vector X into x1, x2
        if size(X, 1) == 2
            % output function value as rowsum
            varargout{1} = 0.6 + sum(sin(arg) + sin(arg).^2 + sin(4*arg)/50, 1);
        else
            % output function value as columnsum
            varargout{1} = 0.6 + sum(sin(arg) + sin(arg).^2 + sin(4*arg)/50, 2);
        end
        
    end
     
end