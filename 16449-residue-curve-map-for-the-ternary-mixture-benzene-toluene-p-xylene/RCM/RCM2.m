% Author: Housam Binous

% Residue Curve Map Computation Using Matlab

% National Institute of Applied Sciences and Technology, Tunis, TUNISIA

% Email: binoushousam@yahoo.com

% Reference :
% M. F. Doherty and M. F. Malone, Conceptual Design of Distillation
% Systems, New York: McGraw-Hill, 2001.

function xdot=RCM2(t,x,flag)

if isempty(flag),

T=x(4);

P=760;

A1=6.87987;B1=1196.76;C1=219.161;
A2=6.99053;B2=1453.43;C2=215.310;
A3=6.95087;B3=1342.31;C3=219.187;

PS1=10^(A1-B1/(C1+T));
PS2=10^(A2-B2/(C2+T));
PS3=10^(A3-B3/(C3+T));

y1=PS1*x(1)/P;
y2=PS2*x(2)/P;
y3=PS3*x(3)/P;

xdot(1)=-x(1)+y1;
xdot(2)=-x(2)+y2;
xdot(3)=-x(3)+y3;
xdot(4)=y1+y2+y3-1;

xdot = xdot';  % xdot must be a column vector

else
   
% Return M
   M = zeros(4,4);
      M(1,1) = 1;
      M(2,2) = 1;
      M(3,3) = 1;
      
   xdot = M;
end