function p = newton_interpolation(eq, degree, interval, verbose)
% June 20, 2013 by Ehsan Behnam.
% p = newton_interpolation(...) computes the newton interpolating 
% polynomial. "eq" is the string containing the original equation
% which will be interpolated. 
% "degree" is the degree of the interpolating polynomial.
% "interval" is the closed interval (e.g. [a b]) for interpolation.
% "verbose" is a logical variable. Set it "true" to see the progress
% of the % function.
% "p" is the symbolic representation of the polynomial. 
% You may evaluate it at x_0 simply by typing subs(p, 'x', x_0)

% Usage example: p = newton_interpolation('exp(x)', 2, [0 1]); 
% returns p =   1.2974 x + 0.84168 x (x - 0.5) + 1 which is a polynomial
% of degree two interpolating e^x on [0 1].

if (nargin == 3)
    verbose = false;
end
if (nargin < 3)
    help('newton_interpolation');
    p = '';
    return;
end
if (numel(interval) ~= 2)
    error('bad interval');
end
a0 = interval(1);
b0 = interval(2);

fx = sym(eq);
x = linspace(a0, b0, degree + 1);
y = subs(fx, 'x', x);

if (verbose)
    disp('The starting values are ...');
    disp([x' y']);
end

% Divided difference algorithm: finding f[x_1, x_2, ..., x_k]
% According to the recursive property: 
% f[x_1,x_2,...,x_{k+1}] = (f[x_2,..., x_{k+1}]-f[x_1,x_k])/(x_{k+1}-x_1)
% Let a(i, j) = f[x_i, ..., x_j]
% Observe that according to the theory, we only need F(i, 1) values.
% Let a(i) = F(i, 1);
a = zeros(degree + 1, 1);
for i = 1:degree + 1
   a(i) = y(i);
end
for i = 2:degree + 1
   for j = degree + 1:-1:i
       a(j) = (a(j) - a(j - 1)) / (x(j) - x(j - i + 1));
   end
end

if (verbose)
    disp(strcat('The newton interpolating poly is formed', ...
                ' as \Sigma(a_i\Pi(x-x_j))'));
    disp('a_i coefficients are ...');
    disp(a);
end

%Establishing the polynomial p:
% High precision is required when transferring from double to string.
% You can change it according to your own application but I have tested
% it for degree <= 10 and the error using 2 * degree is following the 
% the theoretical bound.
precision = 2 * degree; 
p = num2str(a(1), precision);
v = '';
for i = 1:degree
    if (x(i) > 0)
        sign = '-';
    else
        sign = '+';
    end
    if (i == 1)
        v = strcat('(x', sign, num2str(x(i), precision), ')');
    else
        v = strcat(v, '*(x', sign, num2str(x(i), precision), ')');
    end
    if (a(i + 1) > 0)
        p = strcat(p, '+', num2str(a(i + 1), precision), '*', v);
    else
        p = strcat(p, num2str(a(i + 1), precision), '*', v);
    end
end
p = sym(p);
if (verbose)
    disp('The polynomial is ...');
    pretty(p)
end
