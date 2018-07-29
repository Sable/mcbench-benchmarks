function OUT=duffing(t,X)
%DUFFING   Duffing's equation 
%          (a 2nd-order continuous non-autonomous system):
%
%          dx/dt = y
%          dy/dt = -k*y - x^3 + B*cos(t);
%
%     In this demo, k = 0.1, B = 11.
%     Initial conditions: x(0) = 0, y(0) = 0, z(0) = 0  (where z = t)
%     Note: A new state variable z = t is introduced for changing
%           the non-autonomous system to an autonomous one.
%     Reference values: LE1 = 0.114, LE2 = 0, LE3 = -0.214, LD = 2.533
%
%     Other reference values:
%     k = 0.1, B = 10:  LE1 = 0.102, LE2 = 0, LE3 = -0.202, LD = 2.505
%     k = 0.1, B = 12:  LE1 = 0.149, LE2 = 0, LE3 = -0.249, LD = 2.598
%     k = 0.1, B = 13:  LE1 = 0.182, LE2 = 0, LE3 = -0.282, LD = 2.645
%
%     Note: LE2 = 0 is trivial.  All non-autonomous systems have
%     at least one zero Lyapunov exponent that corresponds to
%     the t-component.
%
%     The reference values are from the following references:
%
%     [1] Y. Ueda, "Randomly Transitional Phenomena in the System
%         Governed by Duffing's Equation," J. Stat. Phys. Vol. 20,
%         pp. 181-196, 1979.
%
%     [2] F. C. Moon, Chaotic and Fractal Dynamics, Section 6.4,
%         John Wiley & Sons, 1992.

%     by Steve Wai kam SIU, Jun. 29, 1998.

%Parameters
k=0.1;
B=11;

%Rearrange input data in desired format
%Note: the input data is a column vector
x=X(1); y=X(2);z=X(3);
Q=[X(4),X(7),X(10);
   X(5),X(8),X(11);
   X(6),X(9),X(12)];

%Duffing's equation
dx=y;
dy=-k*y-x^3+B*cos(z);
dz=1;		%where z = t, this transformation is for changing 
                %the non-autonomous system to a autonomous one

DX1=[dx;dy;dz];	%Output data

%Linearized system
J=[    0,    1,          0;
   -3*x^2,  -k,  -B*sin(z);
        0,   0,          0];

%Variational equation
F=J*Q;

%Put output data in a column vector
OUT=[DX1;F(:)];

