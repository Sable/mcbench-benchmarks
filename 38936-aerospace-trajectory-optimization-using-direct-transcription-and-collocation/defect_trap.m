function resid = defect_trap(tk, tkp1, xk, xkp1, uk, ukp1)

% state vector defects - trapezoid method

% input

%  tk   = time at node k
%  tkp1 = time at node k + 1
%  xk   = state vector at node k
%  xkp1 = state vector at node k + 1
%  uk   = control variable vector at node k
%  ukp1 = control variable at node k + 1

% output

%  resid = state defect vector for node k

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global ndiffeq

% compute delta time

hk = tkp1 - tk;

% evaluate equations of motion
% at beginning and end of segment

xdk = dto_rhs (tk, xk, uk);

xdkp1 = dto_rhs (tkp1, xkp1, ukp1);

% compute state vector defect for this node

for i = 1:1:ndiffeq
    
    resid(i) = xkp1(i) - xk(i) - 0.5d0 * hk * (xdk(i) + xdkp1(i));
    
end

