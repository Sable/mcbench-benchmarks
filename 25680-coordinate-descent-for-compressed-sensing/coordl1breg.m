function [u,Energy] = coordl1breg(A,f,lambda,varargin)
%COORDL1BREG   Linearly-constrained L1 minimization with coordinate descent
%   u = COORDL1BREG(A,f,lambda) solves the minimization problem
%
%     min_u ||u||_1   subject to   A*u = f
%
%   where A is an MxN matrix and f is a vector of length M.  Input lambda
%   is a positive parameter used within the algorithm.
%
%   COORDL1BREG(...,'PARAM1',VALUE1,'PARAM2',VALUE2,...) can be used to
%   specify additional parameters:
%     u0           - Initial value of u (default 0)
%     B            - Precomputed A'*A
%     Normalize    - If equal to 1, COORDL1BREG normalizes the columns of A
%                    (default 0; don't normalize)
%     BregTol      - Stopping tolerance for the Bregman loop:
%                    ||Au - f||/||f|| < BregTol (default 1e-5)
%     MaxBregIter  - Maximum number of Bregman iterations (default 1e3)
%     Tol          - Stopping tolerance for inner loop (default 1e-4)
%     MaxIter      - Maximum iterations for inner loop (default 1e3)
%     PlotFun      - A function handle with the syntax PlotFun(u) for
%                    plotting intermediate solutions (default [])
%     Display      - If equal to 1, displays convergence information when
%                    solvers converge (default 1)
%
%   The minimization is solved by Bregman iteration using coordinate 
%   descent to solve the Bregman subproblems, as described in
%     Yingying Li and Stanely Osher, "Coordinate Descent Optimization for 
%     l^1 Minimization with Application to Compressed Sensing; a Greedy 
%     Algorithm" CAM Report 09-17.
%
%   See also coordlsl1.

% Yingying Li 2009

%%% Default parameters %%%
u0 = zeros(size(A,2),1);
MaxIter = 1e3;
MaxBregIter = 1e2;
Tol = 1e-4;
BregTol = 1e-5;
PlotFun = [];
B = [];
Normalize = 0;
Display = 1;

%%% Parse inputs %%%
if nargin >= 2
    parseinput(varargin);
end

if Normalize
    % Normalize matrix A
    A = normalizecols(A);
    B = A'*A;
    B(1:size(A,2)+1:end) = 1;
elseif isempty(B)
    B = A'*A;
end


OutputEnergyFlag = (nargout >= 2);
u = u0;
f0 = f;

for i = 1:MaxBregIter
    if OutputEnergyFlag
        [u,Energy] = coordlsl1(A,f,lambda,'u0',u,'Display',Display,...
            'MaxIter',MaxIter','Tol',Tol,'B',B,'PlotFun',PlotFun);
    else
        u = coordlsl1(A,f,lambda,'u0',u,'Display',Display,...
            'MaxIter',MaxIter','Tol',Tol,'B',B,'PlotFun',PlotFun);
    end    

    if norm(A*u-f0,2) < BregTol*norm(f0,2)
        if Display
            fprintf('Converged in %d Bregman iterations with ||Au - f||/||f|| = %.4e < %.4e.\n',...
                i,norm(A*u-f0,2)/norm(f0,2),BregTol);
        end
        break;
    end

    f = f + (f0-A*u);
end

return;


function parseinput(pvlist)
%PARSEINPUT  Parse varargin list of property/value pairs
Property = {'u0','MaxIter','Tol','BregTol','PlotFun',...
    'B','Display','MaxBregIter','Normalize'};

for k = 1:2:length(pvlist)-1
    if ~ischar(pvlist{k})
        error('Invalid property');
    end

    i = find(strcmpi(pvlist{k},Property));

    if length(i) ~= 1
        error('Invalid property');
    elseif ischar(pvlist{k+1})
        error('Invalid value');
    else
        assignin('caller',pvlist{k},pvlist{k+1});
    end
end
return;


function A = normalizecols(A)
%NORMALIZECOLS  Normalize the columns of a matrix
%   A = NORMALIZECOLS(A)

% Yingying Li 2009

for j = 1:size(A,2)
    A(:,j) = A(:,j)./norm(A(:,j));
end
return;
