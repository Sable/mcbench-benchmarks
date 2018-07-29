
% Rosenbrock test function which has n decision variables and several local optima. global optimum
% is x=[1 1,..., 1]  with f(x)=0. decision variables are bounded in [-5
% 10].

function rosenvalue=test1(x)
rosenvalue=sum(100*(x(1:end-1).^2-x(2:end)).^2+(x(1:end-1)-1).^2);