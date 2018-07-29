% Hump test function which has 2 decision variables, has no local optima.
%has two global optimum. all decision variables are bounded in [-5
% 5].
% is x=[0.0898  - 0.7126]  [-0.0898   0.7126]    with f(x)=0

function hump=test3(x)
hump=4*x(1).^2-2.1*x(1).^4+(1/3)*x(1).^6+x(1)*x(2)-4*x(2).^2+4*x(2).^4;