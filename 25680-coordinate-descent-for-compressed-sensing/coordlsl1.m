function [v,Energy] = coordlsl1(A,f,lambda,varargin)
%COORDLSL1   Least-squares L1 minimization with coordinate descent
%   u = COORDLSL1(A,f,lambda) solves the minimization problem
%
%     min_u ||u||_1 + lambda ||A*u - f||_2^2
%
%   where A is an MxN matrix and f is a vector of length M.
%
%   COORDLSL1(...,'PARAM1',VALUE1,'PARAM2',VALUE2,...) can be used to
%   specify additional parameters:
%     u0           - Initial value of u (default 0)
%     B            - Precomputed A'*A
%     Tol          - Stopping tolerance: |du| < Tol (default 1e-4)
%     MaxIter      - Maximum iterations (default 1e3)
%     PlotFun      - A function handle with the syntax PlotFun(u) for
%                    plotting intermediate solutions (default [])
%     Display      - If equal to 1, displays convergence information when
%                    solver converges (default 1)
%
%   [u,Energy] = COORDLSL1(...) returns a vector of energy values at each
%   iteration (beginning with the first iteration).
%
%   See also coordl1breg.

% Yingying Li 2009

%%% Default parameters %%%
u0 = zeros(size(A,2),1);
MaxIter = 1e3;
Tol = 1e-4;
PlotFun = [];
B = [];
Display = 1;

%%% Parse inputs %%%
if nargin >= 2
    parseinput(varargin);
end

OutputEnergyFlag = (nargout >= 2);  % Check if Energy is an output

if isempty(B)
    B = A'*A;
end

w = diag(B);
NormalizedFlag = all(w == 1);
v = u0;
C = A'*f;

mu = 1/2/lambda;
temp = C;

if OutputEnergyFlag
    Energy = zeros(MaxIter,1);
end

%%% Main Loop %%%
for j = 1:MaxIter    
    if NormalizedFlag
        tilde_v = min(temp + mu, max(0,temp - mu));
        dEnergy = lambda*(v.^2 - tilde_v.^2) + abs(v) - abs(tilde_v) - 2*lambda*temp.*(v-tilde_v);        
    else
        tilde_v = min(temp + mu, max(0,temp - mu))./w;
        dEnergy = lambda*(v.^2 - tilde_v.^2).*w + abs(v) - abs(tilde_v) - 2*lambda*temp.*(v-tilde_v);
    end
    
    [dvchange,i] = max((dEnergy));
    
    if OutputEnergyFlag
        Energy(j) = norm(A*v-f,2)^2*lambda + sum(abs(v));
    end
    
    if ~isempty(PlotFun)
        PlotFun(v);
    end
    
    dv = (v(i)-tilde_v(i));
    
    if abs(dv) < Tol
        if Display
            fprintf('Converged in %d iterations with |du| = %.4e < %.4e.\n',...
                j,abs(dv),Tol);
        end
        break;
    end
  
    temp = temp + dv*B(:,i);

    if NormalizedFlag
        temp(i) = temp(i) - dv;
    else
        temp(i) = temp(i) - dv*w(i);
    end
    
    v(i) = tilde_v(i);
end

if OutputEnergyFlag
    Energy = Energy(1:j);
end

return;


function parseinput(pvlist)
%PARSEINPUT  Parse varargin list of property/value pairs
Property = {'u0','MaxIter','Tol','PlotFun','B','Display'};

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
