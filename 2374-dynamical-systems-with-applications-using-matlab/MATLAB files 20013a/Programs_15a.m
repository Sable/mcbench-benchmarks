% Chapter 15 - Local and Global Bifurcations.
% Programs_15a - Determining the coefficients of the Lyapunov function
% for a Lienard system.
% Copyright Birkhauser 2013. Stephen Lynch.

% V3=[V30;V21;V12;V03], V4=[V40;V31;V22;V13;V04;eta4],
% V5=[V50;V41;V32;V23;V14;V05],V6=[V60;V51;V42;V33;V24;V15;V06;eta6]
% Symbolic Math toolbox required.

% When determining coefficients of V_{4m} set V_{2m,2m}=0.
% When determining coefficients of V_{4m+2} set V_{2m,2m+2}+V_{2m+2,2m}=0.

clear all

syms a1 a2 b2 a3 b3 a4 b4 a5 b5;
A=[3 0 -2 0;0 0 1 0;0 -1 0 0;0 2 0 -3];
B=[b2; 0; a2; 0];

V3=A\B

A=[0 -1 0 0  0 -1;0 3 0 -3 0 -2;0 0 0 1 0 -1;4 0 -2 0 0 0;0 0 2 0 -4 0; 0 0 1 0 0 0];
B=[a3; -2*a2*b2; 0; b3-2*a2^2;0;0];

V4=A\B

A=[5 0 -2 0 0 0;0 0 3 0 -4 0;0 0 0 0 1 0;0 -1 0 0 0 0;0 4 0 -3 0 0;0 0 0 2 0 -5];
B=[b4-10*a2^2*b2/3;0;0;a4-2*a2^3;-2*a2*b3;0];

V5=A\B

A=[6 0 -2 0 0 0 0 0;0 0 4 0 -4 0 0 0;0 0 0 0 2 0 -6 0;0 0 1 0 1 0 0 0;
   0 -1 0 0 0 0 0 -1;0 5 0 -3 0 0 0 -3;0 0 0 3 0 -5 0 -3;0 0 0 0 0 1 0 -1];
B=[b5-6*a2*a4-4*a2^2*b2^2/3+8*a2^4;16*a2^4/3+4*a2^2*b3/3-8*a2*a4/3;0;0;
   a5-8*a2^3*b2/3;-2*a2*b4+8*a2^3*b2+2*a2*b2*b3-4*a4*b2;
   16*a2^3*b2/3+4*a2*b2*b3/3-8*a4*b2/3;0];

V6=A\B

L0=-a1
eta4=V4(6,1);
[n,d]=numden(-3/8*a3+1/4*a2*b2);
L1=n
a3=2*a2*b2;
eta6=V6(8,1);
[n,d]=numden(-5/16*a5+1/8*a2*b4-5/24*a2*b2*b3+5/12*a4*b2);
L2=n

% End of Programs_15a.