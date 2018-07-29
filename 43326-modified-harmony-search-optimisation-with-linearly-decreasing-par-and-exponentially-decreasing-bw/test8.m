% "Zakharov test function which has n decision variables, has no local optima.
%has one global optimum. all decision variables are bounded in [-5
% 10]. One global minimum at x=[0 0,...,0]  with f(x)=0

function s=test8(x)
k=0;

for i=1:numel(x)
   k=k+0.5*i*x(i);
end
s=sum(x.^2)+k.^2+k.^4;

 
