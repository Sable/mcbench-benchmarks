function Y0 = bagleytorvikequation(A,B,C)
% 
% Sample function for solving Bagley-Torvik equation with zero initial conditions:
% A,B,C are coefficients of the Bagley-Torvik equation
% 
% Ay'' + By^(3/2) + Cy = F(t)
% 
% Reference: 
% I. Podlubny, Fractional Differential Equations, Academic Press, 
% San Diego, 1999, ISBN 0125588402. 
% (Correct typos: in Fig. 4 there on page 230 the results for A=B=C=1 are shown,
% replace the text "B=0.5" and "C=0.5" on page 231 with correct "B=1" and
% "C=1")

alpha=1.5; 

% Numerical solution:
h=0.075;
T=0:h:30;
N=30/h + 1;
M=zeros(N,N); % pre-allocate matrix for the system

% (1) Make the matrix for the alpha-th derivative:
Dalpha = ban(alpha,N,h);

% (2) Make the matrix for the second derivative:
D2 = ban(2,N,h);

% (3) Make the matrix for the entire equation:
M=A*D2 + B*Dalpha + C*eye(size(Dalpha));

% Make right-hand side:
F=8*(T<=1)';

% (3) Utilize zero initial conditions:
M = eliminator(N,[1 2])*M*eliminator(N, [1 2])';
F= eliminator(N,[1 2])*F;

% (4) Solve the system BY=F:
Y=M\F;

% (5) Pre-pend the zero values (those due to zero initial conditions)
Y0 = [0; 0; Y];

% Plot the solution:
figure(1)
plot(T,Y0,'g')
grid on


