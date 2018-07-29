% Authors: Nasri Zakia and Housam Binous
% Flash distillation using the SRK equation of state
options = optimset('Display','off');
[X]=fsolve(@zakia2,[0.01 0.3 0.6 0.05 0.01 0.4 0.5 0.01 0.5],options);
Liquid_Composition=[X(1) X(2) X(3) X(4)]
Vapor_Composition=[X(5) X(6) X(7) X(8)]
Vapor_Fraction=X(9)