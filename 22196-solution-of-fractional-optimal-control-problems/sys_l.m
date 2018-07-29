function z = l(neq,t,x,u)

global sys_params C D problem

% z is a scalar.

alpha = sys_params(1);
w_L = sys_params(2);
w_H = sys_params(3);
N = sys_params(4);

% [A,B,C,D] = ssdata(ora_foc(-alpha,N,w_L,w_H));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if problem == 1
    % LTI
    z = C*x*x'*C' + D*u*u'*D' + u*u';

elseif problem == 2
    % LTV
    z = C*x*x'*C' + D*u*u'*D' + u*u';

elseif problem == 3
    % Bang-Bang
    z = 0;
else
    error();
end