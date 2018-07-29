
% Sphere test function which has n decision variables, has no local optima.
% just one global optimum. all decision variables are bounded in [-5.12
% 5.12].
% is x=[0 0,..., 0]  with f(x)=0

function sphere=test2(x)
sphere=sum(x.^2);