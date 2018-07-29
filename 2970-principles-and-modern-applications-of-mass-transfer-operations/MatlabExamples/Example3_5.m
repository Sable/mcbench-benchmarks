function Example3_5
% Example 3.5, p.133 Text
% Uses the function fsolve from the Optimization Toolbox
% and the M-function example3_5 supplied by the user
% X(1) refers to xA (liquid composition)
% X(2) refers to yA (gas composition)
% X(3) refers to gammaA (the activity coefficient)
[X]=fsolve(@example3_5,[0.2 0.5 1.0],optimset('fsolve'));
xA=X(1)
yA=X(2)
gammaA = X(3)

function F = example3_5(x)
F(1)=x(2)-1+0.4*(0.88/(1-x(1)))^1.75;
F(2)=x(3)-0.156-0.622*x(1)*(5.765*x(1)-1);
F(3)=x(2)-10.51*x(1)*x(3);

