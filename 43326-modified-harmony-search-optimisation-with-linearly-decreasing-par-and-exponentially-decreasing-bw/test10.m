% "Powel test function which has n decision variables, has no local optima.
%has one global optimum. all decision variables are bounded in [-4
% 5]. One global minimum at x=[3 -1 0, 1...,3 -1 0 1]  with f(x)=0

function sum=test10(x)
sum=0;

b=numel(x)/4;

for i=1:b
   sum=sum+(x(4*i-3)+10*x(4*i-2)).^2+5*(x(4*i-1)-x(4*i)).^2+(x(4*i-2)-x(4*i-1)).^4+10*(x(4*i-3)-x(4*i)).^4;
end
