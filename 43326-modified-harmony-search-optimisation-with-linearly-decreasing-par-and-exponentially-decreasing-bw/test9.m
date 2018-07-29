% "Griewank test function which has n decision variables, has several local optima.
%has one global optimum. all decision variables are bounded in [-600
% 600]. One global minimum at x=[0 0,...,0]  with f(x)=0


function s=test9(x)
k=1;

for i=1:numel(x)
    k=k*cos(x(i)./sqrt(i));
end
s=sum((x.^2)./4000)-k+1;
 
