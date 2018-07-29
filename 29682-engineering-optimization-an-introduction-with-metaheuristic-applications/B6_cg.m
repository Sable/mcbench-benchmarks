% -----------------------------------------------------------------  %
% Matlab Programs included the Appendix B in the book:               %
%  Xin-She Yang, Engineering Optimization: An Introduction           %
%                with Metaheuristic Applications                     %
%  Published by John Wiley & Sons, USA, July 2010                    %
%  ISBN: 978-0-470-58246-6,   Hardcover, 347 pages                   %
% -----------------------------------------------------------------  %
% Citation detail:                                                   %
% X.-S. Yang, Engineering Optimization: An Introduction with         %
% Metaheuristic Application, Wiley, USA, (2010).                     %
%                                                                    % 
% http://www.wiley.com/WileyCDA/WileyTitle/productCd-0470582464.html % 
% http://eu.wiley.com/WileyCDA/WileyTitle/productCd-0470582464.html  %
% -----------------------------------------------------------------  %
% ===== ftp://  ===== ftp://   ===== ftp:// =======================  %
% Matlab files ftp site at Wiley                                     %
% ftp://ftp.wiley.com/public/sci_tech_med/engineering_optimization   %
% ----------------------------------------------------------------   %


% Simple implementation of the Conjugate Gradient Method             %
% by Xin-She Yang (Cambridge University @ 2009 )                     %
% This part forms a known system Av=b for demo only                  %
% ------------------------------------------------------------------ %

n=50;             % try to use n=50, 250, 500, 5000
A=randn(n,n);     % generate a random square matrix
A=(A+A')/2;       % make sure A is symmetric
v=(1:n)';         % the target solution
b=A*v;            % form a linear system

% Solve the system by the conjugate gradient method
u=rand(n,1);      % initial guess u0
r=b-A*u;          % intial r0
d=r;              % intial d0=r0
delta=10^(-5);    % accuracy

while max(abs(r))>delta
   alpha=r'*r/(d'*A*d);  % alpha_n
   K=r'*r;               % temporary value
   u=u+alpha*d;          % u_{n+1}
   r=r-alpha*A*d;        % r_{n+1}
   beta=r'*r/K;          % beta_n
   d=r+beta*d;           % d_{n+1}
   u'                    % disp u on the screen
end

