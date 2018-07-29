function U = fracdiffdemou(alpha,beta)

% A demo to the article:
% I. Podlubny, A.Chechkin, T. Skovranek, YQ Chen, 
% B. M. Vinagre Jara, "Matrix approach to discrete 
% fractional calculus II: partial fractional differential 
% equations". http://arxiv.org/abs/0811.1355
%
% It illustrates the ease of use of the matrix approach
% to discretization of partial differential equations
% with fractional derivatives with respect to the time 
% variable.
%
% It solves the time-fractional diffusion-wave equation
%  u_{t}^(alpha) (x,t) = a2 * u_{xx}(x,t)
% under non-zero initial condition 
%  u(x,0) = 4*x*(1-x)
% and zero boundary conditions at x = 0 and x = L.
% (In the sample settings below, L=1).
% 
% For alpha =1 we have the test example from the book: 
% W. E. Milne. "Numerical Solution of Differential Equations". 
%               New York: Wiley (London: Chapman & Hall), 1953.
%
% which is the classical heat conduction equation
%  u_{t} (x,t) = a2 * u_{xx}(x,t)
%


a2=1;       % coefficient from the diffusion equation
L = 1;      % length of spatial interval

% Number of spatial steps + 1 is:
m = 21; % 11, 21

% Number of steps in time + 1 is:
n = 148; % 37, 148 

h = L / (m-1);   % spatial step
tau = h^2 / (6*a2);  % time step

% generating the matrix for approximation
B1 = ban(alpha,n-1,tau)';   % alpha-th order derivative with respect to time
TD = kron(B1, eye(m));      % time derivative matrix


B2 = ransym(beta,m,h);      % beta-th order derivative with respect to X
SD = kron(eye(n-1), B2);    % spatial derivative matrix


SystemMatrix = TD - a2*SD;   % matrix corresponding to discretization 
                             % in space and time

                             
% figure(2), spy(SystemMatrix, '.k', 18), figure(1)
                             
% remove columns with '1' and 'm' from SystemMatrix
S = eliminator (m, [1 m]);
SK = kron(eye(n-1), S);
SystemMatrix_without_columns_1_m = SystemMatrix * SK';

% remove rows with '1' and 'm' from SystemMatrix_without_columns_1_m
S = eliminator (m, [1 m]);
SK = kron(eye(n-1), S);
SystemMatrix_without_rows_columns_1_m = SK * SystemMatrix_without_columns_1_m;


                                                                                       
% Initial conditions 
k = 1:m;
U0 = 4*(k-1).*((m-1) - k + 1)*h^2;

% Right hand side
F = -8*ones(size(SystemMatrix_without_rows_columns_1_m,1),1);

% Solution of the system
Y = SystemMatrix_without_rows_columns_1_m\F;

% Reshape solution array -- values for k-th time step 
% are in the k-th column of YS:
YS = reshape(Y,m-2,n-1);
YS = fliplr(YS);

% final solution (take into account the initial condition):
for k = 1:(n-1)
    U (:,k) = YS(:,k)+U0(2:(m-1))';
end

% plot the solution
[rows, columns] = size(U);
U = [ zeros(1, columns); U;  zeros(1, columns)];
U = [U0' U]; 
[XX,YY]=meshgrid(tau*(0:n-1),h*(0:m-1));

mesh(XX,YY,U)
xlabel('t');
ylabel('x');
zlabel('U(x,t)');
title(['\alpha =', num2str(alpha), ',  \beta = ', num2str(beta)])

set(gca, 'xlim', [0 tau*n], 'zlim', [0 1])
box on



