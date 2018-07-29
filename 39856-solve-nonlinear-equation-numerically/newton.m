function [ xs ] = newton( func,dfunc,a,tol )
%Solve a nonlinear equation using the Newton-Raphson method
%       func : a function handle e.g., func = inline(x^2-1);
%       dfunc: derivative of func e.g., func = inline(2*x);
%       a: is a starting point of x
%       tol: is the desired error e.g. 10^-3
x=a;
dx=-feval(func,x)/feval(dfunc,x);
x=x+dx;
tic;
for i=1:1/eps
    dx=-feval(func,x)/feval(dfunc,x);
    x0=x;
    x=x+dx;
    xns(i)=x;
    fxns(i)=feval(func,xns(i));
    error(i) = abs((x-x0)/x) ;
    if error(i) < tol, break; end
end
t=toc;
fprintf('iteration\t|\t\txns\t\t\t|\t\tf(xns)\t\t|\t\terror\n');
fprintf('--------------------------------------------------------------------------\n');
for i=2:length(xns) 
    fprintf('%5d\t\t|\t%10.5f\t\t|\t%10.5f\t\t|\t%10.5f\n',i-1,xns(i),fxns(i),error(i));
end
fprintf('--------------------------------------------------------------------------\n');
format long;
xs=xns(length(xns));
fprintf('\nfinal solution: \n\tx = %-10.10f\n',xns(length(xns)));
fprintf('time elapsed in milliseconds: \n\tt = %-10.10f\n',t*10^3);
end