% Control of a water tank temperature
% Case of Proportional-Integral Control
% Author's Data: Housam BINOUS
% Department of Chemical Engineering
% National Institute of Applied Sciences and Technology
% Tunis, TUNISIA
% Email: binoushousam@yahoo.com 

% function PI_control

function xdot=PI_control(t,x)


V = 100; 
F = 10; 
rho = 1; 
cp = 4.19; 
Q0 = 2500; 
TRset = 80; 
T0 = 20; 
TauSens = 2; 
Kp = 300; 
TauQ = 1;
TauI=9;

QC= Q0 + Kp*(TRset - x(3))+Kp/TauI*x(4);

xdot(1) = 1/(V*rho*cp)*(F*rho*cp*(T0-x(1))+x(2));
xdot(2) = (QC-x(2))/TauQ;
xdot(3) = 1/TauSens*(x(1)-x(3));
xdot(4) = TRset - x(3);

xdot=xdot';