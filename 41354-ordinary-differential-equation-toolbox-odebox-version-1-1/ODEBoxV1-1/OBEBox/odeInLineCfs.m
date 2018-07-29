function X = odeInLineCfs( cfs, x )
%
% Purpose : This function generates the necessary diagonal matrix for the
% ODEbox IVP solver. cfs is a coefficient defined as a MATLAB Inline
% function.
%
% Use (syntax):
%   X = odeInLineCfs( cfs, x );
%
% Input Parameters :
%   cfs: A MATLAB inline function for the coefficient of a differential
%   equation or for the forcing function.
%   x:  The vector of nodes at which the function is to be evaluated
%
% Return Parameters :
%   X: is the diagonal matrix required for the ODEBoxIVPSolver.
%
% Description and algorithms:
%
% References : 
%
% Author :  Matther Harker and Paul O'Leary
% Date :    29. Jan 2013
% Version : 1.0
%
% (c) 2013 Matther Harker and Paul O'Leary
% url: www.harkeroleary.org
% email: office@harkeroleary.org
%
% History:
%   Date:           Comment:
%

% convert the string to an inline function
fx = inline( cfs );
% extract the variable names from the inline
inNames = argnames( fx );
[n,m] = size( inNames);
%
if (n==1)&&(m==1)
    name = inNames{1};
    if strcmp( name,'x')
        % compute if it is a function in x, whereby x is the independent
        % variable.
        X = diag( fx(x) );
        [n,m] = size(X);
        if (n==1)
            X = diag( X * ones(size(x)));
        end;
    else
        error('The inline function may only be a function of x.');
    end;
else
    error('The inline function may only be a function of one variable.');
end;