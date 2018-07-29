function xdot = sys_h(neq,t,x,u)

global sys_params A B C D problem


% xdot must be a column vector with n rows.

alpha = sys_params(1);
w_L = sys_params(2);
w_H = sys_params(3);
N = sys_params(4);

% [A,B,C,D] = ssdata(ora_foc(-alpha,N,w_L,w_H));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if problem == 1
    %LTI
    xdot = A*x + B*(-(C*x+D*u)+u);
elseif problem == 2
    %LTV
    xdot = A*x + B*((C*x+D*u).*t+u);
elseif problem == 3
    %Bang-Bang
    tau = x(end);
    xdot = A*x(2:end-1) + B*u;
    xdot = [tau.*(C*x(2:end-1)+D*u);tau.*xdot;0];
else
    error();
end