function root = newton(f,g,xo,epsilon)
% Program : newton.m
%
% Purpose : find the root of a given single variable function within the
%           given interval
%
% Author :  Aamir Alaud Din
% Date :    20.09.2013
%
% Inputs :  At least three input arguments are required viz., function,
%           derivative of the function, and initial guess
%
% Syntax :  root = newton(f,g,xo)
%           where f is an inline function and is continuous in the given
%           interval
%           e.g., f = inline('sin(x)','x');
%           g is the first derivative of f in the form of inline function
%           and is continuous in the given interval
%           e.g., g = inline('cos(x)','x'); 
%           xo is the initial guess which lies in the given interval
%
% Example:  root = newton(f,g,5)
%           The fourth input argument is the stopping criteria
%           If the function value deceeds epsilon, the loop terminates
%           giving the root. Default is 1e-6.
%
% Syntax :  root = newton(f,g,xo,epsilon)
%           where f, g, xo, and epsilon are explained above.
%
% Example:  root = bisection(f,g,-2,1e-9)

if (nargin < 3)
    error('Less input arguments provided.');
    
elseif (nargin == 3)
    epsilon = 1e-6;
    Iter = 0;
    fprintf('Iteration\t\t   xo\t\t   x1\t\t\tf(x)\t\t\tg(x)\n');
    fprintf('=========\t\t ======\t\t ======\t\t===========\t\t===========\t\t\n');
    while (abs(f(xo)) >= epsilon)
        Iter = Iter + 1;
        if (g(xo) == 0)
            fprintf('g(xo) is zero on iteration number %d',Iter);
            fprintf('\n');
            disp('We can''t compute the root');
            return;
        end
        x1 = xo - (f(xo)/g(xo));
        fprintf('%3d',Iter);
        fprintf('%20.4f',xo);
        fprintf('%12.4f',x1);
        fprintf('%16.4f',f(xo));
        fprintf('%16.4f',g(xo));
        fprintf('\n');
        xo = x1;
    end
    root = xo;
elseif (nargin == 4)
    Iter = 0;
    fprintf('Iteration\t\t   xo\t\t   x1\t\t\tf(x)\t\t\tg(x)\n');
    fprintf('=========\t\t ======\t\t ======\t\t===========\t\t===========\t\t\n');
    while (abs(f(xo)) >= epsilon)
        Iter = Iter + 1;
        if (g(xo) == 0)
            fprintf('g(xo) is zero on iteration number %d',Iter);
            fprintf('\n');
            disp('We can''t compute the root');
            return;
        end
        x1 = xo - (f(xo)/g(xo));
        fprintf('%3d',Iter);
        fprintf('%20.4f',xo);
        fprintf('%12.4f',x1);
        fprintf('%16.4f',f(xo));
        fprintf('%16.4f',g(xo));
        fprintf('\n');
        xo = x1;
    end
    root = xo;
end