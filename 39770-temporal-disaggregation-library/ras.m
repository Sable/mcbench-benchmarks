function F1 = ras(F0,x0,x1,v,u,opG)
% PURPOSE: Bi-proportional adjustment
% ------------------------------------------------------------
% SYNTAX: F1 = ras(F0,x0,x1,v,u,opG);
% ------------------------------------------------------------
% OUTPUT: F1: kxk -> updated matrix
% ------------------------------------------------------------
% INPUT: F0: kxk -> benchmark matrix
%        x0: 1xk -> benchmark output (by cols)
%        x1: 1xk -> updated output (by cols)
%        v: 1xk -> updated F totals (by cols)
%        u: kx1 -> updated F totals (by rows)
%        opG: 1x1 -> graphical info about convergence (optional, default=0)
% ------------------------------------------------------------
% LIBRARY: 
% ------------------------------------------------------------
% SEE ALSO: bal, vdp
% ------------------------------------------------------------
% REFERENCE: Bacharach, M. (1965) "Estimating non-negative matrices from 
% marginal data", International Economic Review, vol. 6, n. 3, p. 294-310.

% written by:
%  Enrique M. Quilis
%  Macroeconomic Research Department
%  Ministry of Economy and Competitiveness
%  <enrique.quilis@mineco.es>

% Version 1.0 [February 2012]

%-------------------------------------------------------------------------
% INITIAL SETTINGS
%-------------------------------------------------------------------------

% Graphic output (optional, default=no graphic)
if (nargin == 5)
    opG = 0;
end

% Max number of iterations
max_iter = 1000;

% Vector of deltas
d = zeros(max_iter,1);

% Tolerance
tol = 1.0000e-007;

% Output on screen
fid = 1;

%-------------------------------------------------------------------------
% BENCHMARK
%-------------------------------------------------------------------------

% Number of products
k = length(x0);

% Number of cells in F
n = k^2;

% Unit vectors
i = ones(k,1);

%-------------------------------------------------------------------------
% INITIAL ESTIMATES
%-------------------------------------------------------------------------

% Benchmark coefficient matrix
A0 = F0 ./ kron(i,x0);

% Initial matrix estimate
F1 = A0 .* kron(i,x1);

%-------------------------------------------------------------------------
% BI-PROPORTIONAL ADJUSTMENT LOOP
%-------------------------------------------------------------------------

iter = 1;
delta = tol * 1.50;
while ((delta > tol) && (iter < max_iter))
    % Row adjustment
    u1 = sum(F1')';
    r1 = u ./ u1;
    F2 = F1 .* kron(i',r1);
    % Column adjustment
    v1 = sum(F2);
    s1 = v ./ v1;
    F2 = F2 .* kron(i,s1);
    % Computing measure of convergence
    delta = sum(sum(abs((F2-F1)))) / n;
    d(iter) = delta;
    % If convergence failed update F matrix
    F1 = F2;   
    iter = iter + 1;
end

%-------------------------------------------------------------------------
% OPTIONAL GRAPHICAL OUTPUT
%-------------------------------------------------------------------------

if (opG == 1)
    h=1:iter;
    fprintf(fid,'RAS Algorithm: iterations  %4d\n ',iter );
    plot(h,d(1:iter),'-ro'); 
    xlabel('Iterations'); ylabel('Measure of converegence: \it{\delta}');
    title ('Convergence');
    grid on;
end
