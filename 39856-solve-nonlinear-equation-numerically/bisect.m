function [ xs ] = bisect( funch, a, b, tol )
%Solve a nonlinear equation using the bisection method
%       func : a function handle e.g., func = inline(x^2-1);
%       a,b : x-interval enclosing solution
%       tol: is the desired error e.g. 10^-3
%       returns xs: which is the final numerical solution of funcx1=0;
%       f1=feval(funch,x1);
x1=a;   f1=feval(funch,x1);
x2=b;   f2=feval(funch,x2);
if f1*f2>=0
    error('no root in interval');
end
tic;
for n=1:1/eps
    if f1*f2<0
        x3=0.5*(x1+x2); fxns(n)=feval(funch,x3);
        if f1*fxns(n)<0
            x2=x3;
            x3=0.5*(x1+x2); fxns(n)=feval(funch,x3);
        end
        if f2*fxns(n)<0
            x1=x3;
            x3=0.5*(x1+x2);
        end
    end
    xns(n)=x3;
    err(n)=abs((x2-x1)/x2);
    if (err(n) < tol), break;  end %stop iterating if error is less than tolerance
end
t=toc;
fprintf('iteration\t|\t\txns\t\t\t|\t\tf(xns)\t\t|\t\terror\n');
fprintf('--------------------------------------------------------------------------\n');
for i=2:length(xns) 
    fprintf('%5d\t\t|\t%10.5f\t\t|\t%10.5f\t\t|\t%10.5f\n',i-1,xns(i),fxns(i),err(i));
end
fprintf('--------------------------------------------------------------------------\n');
format long;
xs=xns(length(xns));
fprintf('\nfinal solution: \n\tx = %-10.10f\n',xns(length(xns)));
fprintf('time elapsed in milliseconds: \n\tt = %-10.10f\n',t*10^3);
end