function y = G2a(X)
% mca for rtd function
% reduced order A matrix - no opamps
% X = [R1 R2 R3 R4 R5 R6 R7 R8 R9 RT E1]
R1=X(1);R2=X(2);R3=X(3);R4=X(4);R5=X(5);R6=X(6);
R7=X(7);R8=X(8);R9=X(9);RT=X(10);E1=X(11);
%
A=[1/R1+1/R4+1/RT -1/RT -1/R4 0 -1/R1;
-1/RT 1/R5+1/R6+1/RT -1/R5 0 0;
-1/R4 0 1/R2+1/R3+1/R4 -1/R3 0;
0 -1/R5 1/R5+1/R7 0 0;
0 0 0 0 -1/R9];
%
B=[0;E1/R6;E1/R2;0;E1/R8];
C=A\B;y=C(4);
