function optimal = fibonacci(f,a,b,n)

% Program : fibonacci.m
%
% Purpose : find the optimal point of a given single 
%           variable function within the given interval
%
% Author :  Aamir Alaud Din
% Date :    26.09.2013
%
% Inputs :  Four input arguments are required viz., function, initial and
%           final points of the interval, and function evaluation number n
%
% Syntax :  optimal = fibonacci(f,a,b)
%           where f is an inline function 
%           e.g., f = inline('sin(x)','x');
%           a and b are initial and final points of the interval
%
% Example:  optimal = fibonacci(f,-3,5)
%
%           Fourth input argument is fibonacci number decided by the user.
%           Default fibonacci number is 11 which gives 10 iterations.
%           Number of iterations is one less then fibonacci number, i.e.,
%           number of iterations = fibonacci number - 1
%
% Syntax:   optimal = fibonacci(f,a,b,n)
%           f, a, and b are described above
%           n is the number of iterations decided by the user
% Example:  optimal = fibonacci(f,0,1,20)
%

if (nargin < 3)
    error('Too few input arguments');
    optimal = 'Fibonacci search is not possible with too few inputs';
    return;
    
elseif (nargin == 3)
    n = 11;
    fss = [1,1];
    for ii = 1:(n-1)
        fs = fss(end) + fss(end-1);
        fss = [fss,fs];
    end
    
    disp('Iteration          N          x1              x2             f(x1)           f(x2)');
    disp('=========        ===       ========        ========        =========       =========');
    Iter = 0;
    for jj = n:-1:2
        Iter = Iter + 1;
        L = b - a;
        x1 = a + ((fss(jj-1)/fss(jj+1))*L);
        x2 = b - ((fss(jj-1)/fss(jj+1))*L);
        if (f(x1) < f(x2))
            b = x2;
        elseif (f(x1) > f(x2))
            a = x1;
        elseif (f(x1) == f(x2))
            a = x1;
            b = x2 + 0.0001;
        end
        fprintf('%3d', Iter);
        fprintf('\t\t\t\t');
        fprintf('%4d', jj-1);
        fprintf('\t');
        fprintf('%11.4f', x1);
        fprintf('\t\t');
        fprintf('%11.4f', x2);
        fprintf('\t\t');
        fprintf('%12.4f', f(x1));
        fprintf('\t\t');
        fprintf('%12.4f', f(x2));
        fprintf('\n');
    end
    optimal = min(x1,x2);
    
elseif (nargin == 4)
    fss = [1,1];
    for ii = 1:(n-1)
        fs = fss(end) + fss(end-1);
        fss = [fss,fs];
    end
    
    disp('Iteration          N          x1              x2             f(x1)           f(x2)');
    disp('=========        ===       ========        ========        =========       =========');
    Iter = 0;
    for jj = n:-1:2
        Iter = Iter + 1;
        L = b - a;
        x1 = a + ((fss(jj-1)/fss(jj+1))*L);
        x2 = b - ((fss(jj-1)/fss(jj+1))*L);
        if (f(x1) < f(x2))
            b = x2;
        elseif (f(x1) > f(x2))
            a = x1;
        elseif (f(x1) == f(x2))
            a = x1;
            b = x2 + 0.0001;
        end
        fprintf('%3d', Iter);
        fprintf('\t\t\t\t');
        fprintf('%4d', jj-1);
        fprintf('\t');
        fprintf('%11.4f', x1);
        fprintf('\t\t');
        fprintf('%11.4f', x2);
        fprintf('\t\t');
        fprintf('%12.4f', f(x1));
        fprintf('\t\t');
        fprintf('%12.4f', f(x2));
        fprintf('\n');
    end
    optimal = min(x1,x2);
    
elseif (nargin > 4)
    error('Too many input arguments');
    optimal = 'Fibonacci search is not possible with too many inputs';
    return
    
end