%%% Projection onto constrained force space without constraint
%%% stabilization

% Course: Robotic Manipulation and Mobility
% Advisor: Dr. V. Krovi
% 
% Homework Number: MIDTERM
% 
% Names: Sourish Chakravarty 
% 	Hrishi Lalit Shah


function [dX]= ROBO_midterm_f2(t,X)

global l1 lc1 m1 j1 tau1 l2 lc2 m2 j2 tau2 g Lambda1

th1=X(1);
x2=X(2);
y2=X(3);
th2=X(4);

th1d= X(5);
x2d=X(6);
y2d=X(7);
th2d= X(8);
%%%%%%%%%%%%%%%%%%%%%%% CREATING IMPORTANT MATRICES IN THE GOVERNING EQUATION
s1=sin(th1);
s2=sin(th2);
c1=cos(th1);
c2=cos(th2);

%%%% Element - 1
M1= [j1+m1*(lc1^2)];
E1= [1,-1];
G1= [m1*lc1*c1*g];
% B11 = [-l1*s1, l1*c1];
% B12 = [-m1*lc1*c1];

%%%% Element - 2
M2= [m2, 0, 0;
     0, m2, 0;
     0, 0, j2];
E2= [ 0; 0; 1];
G2= [0; m2*g; 0];
% B21= [-1, 0;
%      0, -1;
%      -lc2*s2, lc2*c2];
% B22= [0, -m2, 0]';   

%%%% Constraints
C= [x2-l1*c1-lc2*c2;
    y2-l1*s1-lc2*s2];
A= [l1*s1, 1, 0, lc2*s2;
    -l1*c1, 0, 1, -lc2*c2];% Jacobian of constraint matrix
Ad = [l1*c1*th1d, 0, 0, lc2*c2*th2d;
     l1*s1*th1d, 0, 0, lc2*s2*th2d]; % Derivative of matrix A
S = [1, 0;
    -l1*s1, -lc2*s2;
    l1*c1, lc2*c2;
    0, 1]; % Null space of A or Feasible Motion 
Sd = [0, 0;
    -l1*c1*th1d, -lc2*c2*th2d;
    -l1*s1*th1d, -lc2*s2*th2d;
    0, 0]; % Derivative of S matrix 

%%%%%%%%%%%%%%%%%%%%%%% PROJECTION ONTO CONSTRAINED FORCE SPACE

M=[M1, zeros(1,3);
    zeros(3,1), M2];
E=[E1;
    zeros(3,1),E2];
G= [G1;G2];
T =[tau1; tau2];
V=zeros(4,1);

Qd = [th1d, x2d, y2d, th2d]';

t1= inv([M, A';
        A, zeros(2,2)]); % since m=2;
t2= [E*T-V-G; -Ad*Qd];
t3= t1*t2;

dX(1:4,1)= [th1d,x2d,y2d,th2d]';
dX(5:8,1)= t3(1:4);
lam = t3(5:end);
Lambda1 = [Lambda1;lam];%%% Passing instantaneous values of Lagrange multipliers back to main function
return