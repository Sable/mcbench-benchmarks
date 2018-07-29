function Example3_3
% Example 3.3, p.124 Text
% Uses the function fsolve from the Optimization Toolbox
% and the M-function example3_3 supplied by the user
% X(1) refers to xA (liquid composition)
% X(2) refers to LA (moles of ammonia in liquid phase)
% X(3) refers to yA (gas composition)
% X(4) refers to gammaA (the activity coefficient)
[X]=fsolve(@example3_3,[0.3 0.2 0.3 .5],optimset('fsolve'));
xA=X(1)
LA=X(2)
yA=X(3)
gammaA = X(4)

function F = example3_3(x)
F(1)=x(1)-x(2)/(x(2)+2.5);
F(2)=x(3)-(0.588-x(2))/(1.197-x(2));
F(3)=0.156+0.622*x(1)*(5.765*x(1)-1)-x(4);
F(4)=10.51*x(4)*x(1)-x(3);
