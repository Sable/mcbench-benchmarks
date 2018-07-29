% This is a sample code from Appendix A.6 of the following book:
%
%    Zhuang Jiao, YangQuan Chen, Igor Podlubny, 
%    Distributed-Order Dynamic Systems: Stability, Simulation, 
%    Applications and Perspectives (Springer, London, 2012),
%    ISBN ISBN 978-1-4471-2851-9,
%    http://www.springer.com/engineering/control/book/978-1-4471-2851-9
%
% (C) Igor Podlubny, 2011

clear all;

% Check if the FEX package 36574 is on your MATLAB path, 
% and if not, then suggest downloading the FEX submission #36574 
% "Demos for investigating distributed-order linear time-invariant systems"
% by Zhuang Jiao, which contains the Matlab code from Appendices 1-3
% of the same book
Explanation = ['You may be interested in downloading ' ...
'Zhuang Jiao''s FEX submission #36574' sprintf('\n')...
'(Demos for investigating distributed-order linear ' ... 
'time-invariant systems)', sprintf('\n')...
'which contains the Matlab code from Appendices 1-3 to the same book.' ];
if ~(exist('stabbound_dods', 'file') == 2)
    P = suggestFEXpackage(36574, Explanation); 
end

% Check if the FEX package 22071 is on your MATLAB path, 
% and if it is not there, then require the FEX packages 
% 31069 ("requireFEXpackage") and 22071 ("Matrix approach 
% to discretization of ODEs and PDEs of arbitrary real order"):
if ~(exist('ban', 'file') == 2 && exist('fan', 'file') == 2 && exist('eliminator', 'file') == 2)
    P = requireFEXpackage(31069); % "requireFEXpackage" 
    P = requireFEXpackage(22071);  % "Matrix approach..."
end


alpha = '2*alf' ; beta = 2;  % First, define the orders:
a2 = 1;       % coefficient from the diffusion equation
L = 1;      % length of spatial interval

% Number of spatial steps + 1 is:
m = 21; % 11, 21
% Number of steps in time + 1 is:
n = 148; % 37, 148 
h = L/(m-1);   tau = h^2/(6*a2);   % space step, time step


% generating the matrix for approximation
% alpha-th order derivative with respect to time
B1 = doban(alpha, [0 1], 0.01, n-1, tau)';       
TD = kron(B1, eye(m));     % time derivative matrix
B2 = ransym(beta,m,h);     % beta-th order derivative with respect to X
SD = kron(eye(n-1), B2);   % spatial derivative matrix
SystemMatrix = TD - a2*SD; % matrix corresponding to discretization 
                           % in space and time
                             
% remove columns with '1' and 'm' from SystemMatrix
S = eliminator (m, [1 m]); SK = kron(eye(n-1), S);
SystemMatrix_without_columns_1_m = SystemMatrix * SK';

% remove rows with '1' and 'm' from SystemMatrix_without_columns_1_m
S = eliminator (m, [1 m]);    SK = kron(eye(n-1), S);
SystemMatrix_without_rows_columns_1_m =  ...
                 SK * SystemMatrix_without_columns_1_m;

% Right hand side
F = 8*ones(size(SystemMatrix_without_rows_columns_1_m,1),1);

% Solve the system
Y = SystemMatrix_without_rows_columns_1_m\F;

% Reshape solution array -- values for k-th time step 
% are in the k-th column of YS:
YS = reshape(Y,m-2,n-1);
YS = fliplr(YS);
U = YS;

% plot the solution
[rows, columns] = size(U);
U = [ zeros(1, columns); U;  zeros(1, columns)];
U = [zeros(1,m)' U]; 
[XX,YY]=meshgrid(tau*(0:n-1),h*(0:m-1));

mesh(XX,YY,U)
xlabel('t'); ylabel('x'); zlabel('y(x,t)');
title(['\phi =', num2str(alpha), ',  \beta = ', num2str(beta)])
set(gca, 'xlim', [0 tau*n], 'zlim', [0 1]);  box on
