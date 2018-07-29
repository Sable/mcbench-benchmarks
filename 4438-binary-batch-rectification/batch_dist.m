% Batch Rectifier for Binary Systems
% Case of Acetone - Methanol Binary Mixture and 8 Stages Rectification System (including the reboiler)
% Author's Data: Housam BINOUS
% Department of Chemical Engineering
% National Institute of Applied Sciences and Technology
% Tunis, TUNISIA
% Email: binoushousam@yahoo.com 

%Acetone = component 1
%Methanol = component 2 


function xdot=batch_dist(t,x,flag)

% Gas Constant and Total Pressure
R = 1.987; P = 760;

% R, V, L and D are reflux ratio and vapor, liquid and distillate flow rates in kmol/hr 

V=10;
R=10;

D=V/(R+1);
L=V-D;


% Molar holdup in reflux drum and in plates are M0 and M

M0=100;
M=5;

% Liquid mole fractions for Acetone and Temperatures in Stages 0-8
% are x(1), T(1), x(2), T(2), x(3), T(3) .. x(9) and T(9) 
% Liquid remaining in reboiler is x(10)

MB=x(10);

for i=1:9
T(i)=x(10+i);
end

if isempty(flag),

% Vapor Pressure Using Antoine Equation    

A1 = 7.11714; B1 = 1210.595; C1 = 229.664;
A2 = 8.08097; B2 = 1582.271; C2 = 239.726;

for i = 1:9,
Psat1(i)=10.^(A1-B1/(C1+T(i)));
Psat2(i)=10.^(A2-B2/(C2+T(i)));
end

% Binary inetraction Parameters and Activities for Van Laar Model

A21 = 0.6184; 
A12 = 0.5797;

for i = 1:9,
G1(i) = exp(A12*(A21*(1 - x(i))/(A12*x(i) + A21*(1 - x(i))))^2);
G2(i) = exp(A21*(A12*x(i)/(A12*x(i) + A21*(1 - x(i))))^2);
end

% Vapor mole fractions for Acetone - Chloroform - Methanol

for i = 1:9,
y(i)=x(i)*G1(i)*Psat1(i)/P;
end

% Differential Algeraic Equations for residue curve map calculation

xdot(1)=1/M0*(-(L+D)*x(1)+V*y(2));

xdot(2)=1/M*(L*(x(1)-x(2))+V*(y(3)-y(2)));
xdot(3)=1/M*(L*(x(2)-x(3))+V*(y(4)-y(3)));
xdot(4)=1/M*(L*(x(3)-x(4))+V*(y(5)-y(4)));
xdot(5)=1/M*(L*(x(4)-x(5))+V*(y(6)-y(5)));
xdot(6)=1/M*(L*(x(5)-x(6))+V*(y(7)-y(6)));
xdot(7)=1/M*(L*(x(6)-x(7))+V*(y(8)-y(7)));
xdot(8)=1/M*(L*(x(7)-x(8))+V*(y(9)-y(8)));

xdot(9)=1/x(10)*(L*x(8)-V*y(9));

xdot(10)=L-V;

for i=1:9
xdot(i+10) = (-x(i)*G1(i)*Psat1(i) - (1-x(i))*G2(i)*Psat2(i) + P)/P;
end

xdot = xdot';  % xdot must be a column vector

else
   
% Return M
   M = zeros(19,19);
   for i = 1:10,
      M(i,i) = 1;
   end
   xdot = M;
end
