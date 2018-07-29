% This is a sample code from Appendix A.4 of the following book:
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


% (1) Prepare constants and nodes 
%     (this is the longest part of the script):
h = 0.01;           % step of discretization 
t = 0:h:5;          % discretization nodes
N = length(t) + 1;  % number of nodes
B = 0.1;            % coefficient of the equation 
f = '0 + 0*t';      % right-hand-side
M = zeros(N,N);     % pre-allocate matrix M for the system

% (2) Write the discretization matrix:
M = doban('6*alf.*(1-alf)', [0 1], 0.01, N-1, h) + B*eye(N-1,N-1);

% (3) Compute the right-hand side at discretization nodes:
F = eval ([f '-B'], t)';

% (4) Utilize zero initial condition:
M = eliminator(N-1,[1])*M*eliminator(N-1, [1])';
F = eliminator(N-1,[1])*F;

% (5) And solve the system MY=F:
Y = M\F;

% (6) Pre-pend the zero initial value 
Y0 = [0; Y];

% and plot the solution:
U = Y0 + 1;
plot(t, U, 'k')
