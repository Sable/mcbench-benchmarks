function [ xs ] = secant( func, a, b, tol )
%Numerically evaluate root of func around x=a using Secant Method
%Solve a nonlinear equation using the secant method
%       func : a function handle e.g., func = inline(x^2-1);
%       a,b : x-interval enclosing solution
%       tol: is the desired error e.g. 10^-3
%       returns xs: which is the final numerical solution of func
x(1)=a;   f(1)=feval(func,x(1));
x(2)=b;   f(2)=feval(func,x(2));
tic;
for i=1:1/eps
    x(3)=x(2)-( f(2)*(x(1)-x(2)) )/( f(1)-f(2) );
    x(1)=x(2);  f(1)=feval(func,x(1));
    x(2)=x(3);  f(2)=feval(func,x(2));
    xns(i)=x(3);
    fxs(i)=feval(func,xns(i));
    error(i)=abs((x(2)-x(1))/x(2));
    if (error(i) < tol) break;  end %stop iterating if error is less than tolerance
end
t=toc;
fprintf('iteration\t|\t\txns\t\t\t|\t\tf(xns)\t\t|\t\terror\n');
fprintf('--------------------------------------------------------------------------\n');
for i=2:length(xns) 
    fprintf('%5d\t\t|\t%10.5f\t\t|\t%10.5f\t\t|\t%10.5f\n',i-1,xns(i),fxs(i),error(i));
end
fprintf('--------------------------------------------------------------------------\n');
format long;
xs=xns(length(xns));
fprintf('\nfinal solution: \n\tx = %-10.10f\n',xns(length(xns)));
fprintf('time elapsed in milliseconds: \n\tt = %-10.10f\n',t*10^3);
end