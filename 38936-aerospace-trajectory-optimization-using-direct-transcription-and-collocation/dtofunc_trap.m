function [f, g] = dtofunc_trap (x)

% objective function and equality constraints

% trapezoidal collocation method

% inputs

%  x = current nlp variable values

% outputs

%  f = vector of equality constraints and
%      objective function evaluated at x

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global nc_defect ndiffeq nnodes nlp_state ncv tarray

% compute state vector defect equality constraints

for k = 1:1:nnodes - 1

    % time elements

    tk = tarray(k);

    tkp1 = tarray(k + 1);

    % state vector elements

    if (k == 1)
        
       % first node
       
       nks = 0;
       
       nkp1s = ndiffeq;
       
    else
        
       % reset to previous node
       
       nks = (k - 1) * ndiffeq;
       
       nkp1s = nks + ndiffeq;
       
    end
   
    for i = 1:1:ndiffeq
        
        xk(i) = x(nks + i);

        xkp1(i) = x(nkp1s + i);
        
    end

    % control variable elements

    if (k == 1)
        
       % first node
       
       nkc = nlp_state;
       
       nkp1c = nkc + ncv;
       
    else
        
       % reset to previous node
       
       nkc = nlp_state + (k - 1) * ncv;
       
       nkp1c = nkc + ncv;
       
    end

    for i = 1:1:ncv
        
        uk(i) = x(nkc + i);

        ukp1(i) = x(nkp1c + i);
        
    end

    % compute state vector defects for current node

    reswrk = defect_trap(tk, tkp1, xk, xkp1, uk, ukp1);

    % load defect array for this node

    for i = 1:1:ndiffeq
        
        resid(nks + i) = reswrk(i);
        
    end
end

% set active defect constraints
% (offset by 1)

for i = 1:1:nc_defect
    
    f(i + 1) = resid(i);
    
end

% current final state vector

xfinal(1) = x(nlp_state - 2);

xfinal(2) = x(nlp_state - 1);

xfinal(3) = x(nlp_state);

% objective function (maximize final radius)

f(1) = -xfinal(1);

% compute auxillary equality constraints (final boundary conditions)

f(nc_defect + 2) = xfinal(2);

f(nc_defect + 3) = xfinal(1) * xfinal(3)^2 - 1.0;

% transpose

f = f';

% no derivatives

g = [];
