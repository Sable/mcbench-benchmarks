% "Sum squares test function which has n decision variables, has no local optima.
%has one global optimum. all decision variables are bounded in [-10
% 10]. One global minimum at x=[0 0,...,0]  with f(x)=0

function sum=test7(x)
sum=0;

for i=1:numel(x)
    sum=sum+i*x(i).^2;
end
 
