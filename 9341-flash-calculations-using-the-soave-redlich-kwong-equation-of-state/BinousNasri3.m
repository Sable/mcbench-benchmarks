% Authors: Nasri Zakia and Housam Binous

% True Vapor Pressure using the SRK equation of state

options = optimset('Display','off');
[X]=fsolve(@zakia3,[0.01 0.3 0.6 0.05 0.1 0.5 0.3 0.01 100],options);
Liquid_Composition=[X(1) X(2) X(3) X(4)]
Vapor_Composition=[X(5) X(6) X(7) X(8)]
True_Vapor_Pressure=X(9)