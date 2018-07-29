function v = rtd(X)
% Dc RTD output
% R1 R2 R3 R4 R5 R6 R7 R8 R9 RT E1
% 1  2  3  4  5  6  7  8  9  10 11
%
Y=4; % N = 0, U = 4, and M = 1 not required for dc.
%
% The following adds to execution time, but is given for clarity.
%
R1=X(1);R2=X(2);R3=X(3);R4=X(4);R5=X(5);R6=X(6);R7=X(7);
R8=X(8);R9=X(9);RT=X(10);E1=X(11);
%
% Simplify A1 with the following substitutions
%
G1=1/R1+1/R4+1/RT;
G2=1/R5+1/R6+1/RT;
G3=1/R2+1/R3+1/R4;
G4=1/R5+1/R7;
%
A1=[G1 -1/RT -1/R4 0 -1/R1;
      -1/RT G2 -1/R5 0 0;
      -1/R4 0 G3 -1/R3 0;
      0 -1/R5 G4 0 0;
      0 0 0 0 1];
%
B2=[0; E1/R6;E1/R2;0;-E1*R9/R8];
%   
V=A1\B2;v=V(Y);
% For dc circuits (no inductors or capacitors), this is as
% far as we have to go.  


