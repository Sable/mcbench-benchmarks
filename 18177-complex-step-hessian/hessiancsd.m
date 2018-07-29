function [A,g,z]=hessiancsd(fun,x)
% HESSIANCSD    Complex Step Hessian
% H = hessiancsd(f,x) returns the numberical (m x n) Hessian matrix of a 
% scalar function, f(x) at the refdrence point, x (n-vector).
% In addition,
% [H,g] = jacobiancsd(f,x) also returns the gradient function, g=f'(x).
% With all outputs
% [H,g,z] = jacobiancsd(f,x) returns the function value, z=f(x) as the third output.
%
% Example
% f=@(x)x(1)*x(2)^2+x(1)*x(3)^2+x(1)^2;
% x=1:3;
% [H,g,z]=hessiancsd(f,x)
% H =
%     2     4     6
%     4     2     0
%     6     0     2
% g =
%    15
%     4
%     6
% z =
%    14
%
% By Yi Cao at Cranfield University, 02/01/2008
%
if nargout>2
    z=fun(x);                       % function value
end
n=numel(x);                         % size of independent
A=zeros(n);                         % allocate memory for the Hessian matrix
g=zeros(n,1);                       % allocate memory for the gradient matrix
h=sqrt(eps);                        % differentiation step size
h2=h*h;                             % square of step size
for k=1:n                           % loop for each independent variable 
    x1=x;                           % reference point
    x1(k)=x1(k)+h*i;                % increment in kth independent variable
    if nargout>1
        v=fun(x1);                  % function call with a comlex step increment
        g(k)=imag(v)/h;             % the kth gradient
    end
    for l=k:n                       % loop for off diagonal Hessian
        x2=x1;                      % reference with kth increment
        x2(l)=x2(l)+h;              % kth + lth (positive real) increment
        u1=fun(x2);                 % function call with a double increment
        x2(l)=x1(l)-h;              % kth + lth (negative real) increment
        u2=fun(x2);                 % function call with a double increment
        A(k,l)=imag(u1-u2)/h2/2;    % Hessian (central + complex step)
        A(l,k)=A(k,l);              % symmetric
    end
end
