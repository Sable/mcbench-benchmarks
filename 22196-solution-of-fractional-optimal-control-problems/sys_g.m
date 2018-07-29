function J = sys_g(neq,t,x0,xf)

global sys_params A B C D problem

% J is a scalar.

alpha = sys_params(1);
w_L = sys_params(2);
w_H = sys_params(3);
N = sys_params(4);

% [A,B,C,D] = ssdata(ora_foc(-alpha,N,w_L,w_H));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
F_NUM = neq(5);

if problem == 1
    % LTI
    J = 0*C*xf;
elseif problem == 2
    % LTI
    J = 0*C*xf;
elseif problem == 3
    %Bang-bang
    if F_NUM == 1
        J = x0(end);
    elseif F_NUM == 2
        J = xf(1)/300.0 - 1;
    elseif F_NUM == 3
        J = C*xf(2:end-1);
    end
else
    error();
end