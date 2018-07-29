% Rastrigin test function which has n decision variables, has several local optima.
%hasone global optimum. all decision variables are bounded in [-5.12
% 5.12].
% is x=[0 0,... 0]  with f(x)=0

function rastrigin=test4(x)
rastrigin=10*numel(x)+sum(x.^2-10*cos(2*pi*x));