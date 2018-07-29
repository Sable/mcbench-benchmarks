% This is a sample code from Appendix A.5 of the following book:
%
%    Zhuang Jiao, YangQuan Chen, Igor Podlubny, 
%    Distributed-Order Dynamic Systems: Stability, Simulation, 
%    Applications and Perspectives (Springer, London, 2012),
%    ISBN ISBN 978-1-4471-2851-9,
%    http://www.springer.com/engineering/control/book/978-1-4471-2851-9
%
% (C) Igor Podlubny, 2011


clear all

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

% (1) Prepare constants and nodes (this is the longest part of the script):
alpha = 1.5;
A = 1; B = 1; C = 1;  % coefficients of the Bagley-Torvik equation
h = 0.075;            % step of discretization
T = 0:h:30;           % nodes
N = 30/h + 1;         % number of nodes
M = zeros(N,N);       % pre-allocate matrix M for the system

% (2) Make the matrix for the entire equation -- this is really easy:
M = A*ban(2,N,h) + B*doban('6*alf.*(1-alf)', [0.01 1], 0.01, N, h) + C*eye(N,N);

% (3) Make right-hand side:
F = 8*(T<=1)';

% (4) Utilize zero initial conditions:
M = eliminator(N,[1 2])*M*eliminator(N, [1 2])';
F = eliminator(N,[1 2])*F;

% (5) Solve the system MY=F:
Y = M\F;

% (6) Pre-pend the zero values (those due to zero initial conditions)
Y0 = [0; 0; Y];

% Plot the solution:
plot(T,Y0,'k:', 'linewidth', 1)
grid on



