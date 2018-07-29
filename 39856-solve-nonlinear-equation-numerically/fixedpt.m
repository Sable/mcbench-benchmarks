function [ xs ] = fixedpt( f, g, a, b, tol )
%Numerically evaluate root of g(x)=x using the fixed point method
%Solve a nonlinear equation using the fixed-point method
%       f : a function handle, 
%       g : the function f rewritten as g(x)=x
%       for example:
%           f=inline('x^2-x-1') this equation solves for the golden ratio aka phi
%           g=inline('1+1/x') g(x)=x=1/x+1 is obtained from f(x)=x^2-x-1 by dividing f by x and rearranging 
%       a,b : x-interval enclosing solution
%       tol: is the desired error e.g. 10^-3
%       returns xs: which is the final numerical solution of funcx1=0;
%       f1=feval(funch,x1);
x(1)=a;   x(2)=b;             %initial interval enclosing solution
tic;
for i=1:1/eps
    x(2)=feval(g,x(1));
    x(1)=x(2);
    x(2)=feval(g,x(1));
    xns(i)=x(2);               %numerical solution of x
    fxs(i)=feval(f,xns(i));
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